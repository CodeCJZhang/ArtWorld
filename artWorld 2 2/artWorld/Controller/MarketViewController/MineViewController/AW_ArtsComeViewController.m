//
//  AW_ArtsComeViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/22.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_ArtsComeViewController.h"

@interface AW_ArtsComeViewController ()
/**
 *  @author cao, 15-10-22 15:10:46
 *
 *  关于艺天下界面
 */
@property (weak, nonatomic) IBOutlet UIWebView *artComeWebView;

@end

@implementation AW_ArtsComeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"关于艺天下";
    //进行请求
    [self sendGetRequestWithNSURLSession];
    self.artComeWebView.scrollView.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PostMenthod
-(void)sendGetRequestWithNSURLSession{
    
    NSURL * urlString = [NSURL URLWithString:@"http://www.artscome.com"];
    //创建session对象
    NSURLSession * session = [NSURLSession sharedSession];
    //创建task对象
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:urlString completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%d",[NSThread isMainThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.artComeWebView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:urlString];
        });
    }];
    //执行task
    [dataTask resume];
}

#pragma mark - ButtonClick Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
