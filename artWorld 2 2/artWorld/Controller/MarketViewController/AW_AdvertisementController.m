//
//  AW_AdvertisementController.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/27.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_AdvertisementController.h"
#import "AFNetworking.h"
#import "AW_Constants.h"

@interface AW_AdvertisementController ()
/**
 *  @author cao, 15-11-27 23:11:36
 *
 *  广告html
 */
@property (weak, nonatomic) IBOutlet UIWebView *AdvertisementWebView;

@end

@implementation AW_AdvertisementController

#pragma mark - getData Menthod
-(void)getHtmlString{
    NSDictionary * dict = @{};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * htmlDict = @{@"jsonParam":str,@"token":@"",@"param":@"getAbout"};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:ARTSCOME_INT parameters:htmlDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
       NSString * info = responseObject[@"info"];
        if ([responseObject[@"code"]intValue] == 0) {
        [self.AdvertisementWebView loadHTMLString:info baseURL:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xf6f7f8);
    [self getHtmlString];
    //添加左侧返回按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回箭头"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  style:0 target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClicked Menthod

-(void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
