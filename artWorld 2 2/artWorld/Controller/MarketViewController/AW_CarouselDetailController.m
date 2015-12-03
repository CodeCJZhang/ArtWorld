//
//  AW_CarouselDetailController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/17.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_CarouselDetailController.h"

@interface AW_CarouselDetailController ()
/**
 *  @author cao, 15-11-17 21:11:49
 *
 *  轮播图详情
 */
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

@end

@implementation AW_CarouselDetailController

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailWebView.scrollView.bounces = NO;
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"";
    [self sendGetRequestWithNSURLSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick Menthod
-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PostMenthod
-(void)sendGetRequestWithNSURLSession{

    NSString * URLString = [NSString stringWithFormat:@"%@",self.URLString];
    NSURL * urlString = [NSURL URLWithString:URLString];
    //创建session对象
    NSURLSession * session = [NSURLSession sharedSession];
    //创建task对象
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:urlString completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%d",[NSThread isMainThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.detailWebView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:urlString];
        });
    }];
    //执行task
    [dataTask resume];
}

@end
