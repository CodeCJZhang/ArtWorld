//
//  AW_OpenShopViewController.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/21.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_OpenShopViewController.h"

@interface AW_OpenShopViewController ()
/**
 *  @author cao, 15-10-21 22:10:15
 *
 *  申请开店视图
 */
@property (weak, nonatomic) IBOutlet UIWebView *openShopView;

@end

@implementation AW_OpenShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.openShopView.scrollView.bounces = NO;
    
    //一定要添加这句话要不然navigationBar会盖住view
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"申请开店";
    //发送请求
    [self sendGetRequestWithNSURLSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PostMenthod
-(void)sendGetRequestWithNSURLSession{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * user_id = [user objectForKey:@"user_id"];
    NSString * URLString = [NSString stringWithFormat:@"http://www.artscome.com:8080/yitianxia/mobile/register?user_id=%@",user_id];
    NSURL * urlString = [NSURL URLWithString:URLString];
    //创建session对象
    NSURLSession * session = [NSURLSession sharedSession];
    //创建task对象
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:urlString completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%d",[NSThread isMainThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.openShopView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:urlString];
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
