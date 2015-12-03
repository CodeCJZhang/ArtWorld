//
//  CJSysMessageDetailsController.m
//  artWorld
//
//  Created by 张晓旭 on 15/11/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJSysMessageDetailsController.h"
#import "IMB_Macro.h"
#import "AFNetworking.h"
#import "MBProgressHUD+NJ.h"

#define padding 8

@interface CJSysMessageDetailsController ()

{
    NSDictionary *messageDetailsDict;
}

//消息内容
@property (nonatomic,strong) UITextView *messageContent;

@end

@implementation CJSysMessageDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self request];
}

- (void)request
{
    //借口数据：
    NSDictionary *fieldDic = @{@"id":_message_ID};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"systemNewsDetailed",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             messageDetailsDict = [NSDictionary dictionaryWithDictionary:responseObject[@"info"]];
             NSLog(@"请求结果:%@",responseObject);
             [self interfaceLayout];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

//界面布局
-(void)interfaceLayout
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[messageDetailsDict valueForKey:@"title"]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    _messageContent = [[UITextView alloc]initWithFrame:CGRectMake(padding, padding, kSCREEN_WIDTH - padding * 2, kSCREEN_HEIGHT - padding * 2 - 44)];
    _messageContent.editable = NO;
    _messageContent.font = [UIFont boldSystemFontOfSize:15];
    _messageContent.layer.borderWidth = 1.0;
    _messageContent.layer.cornerRadius = 6.0;
    _messageContent.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] CGColor];
    _messageContent.text = [NSString stringWithFormat:@"%@",[messageDetailsDict valueForKey:@"content"]];
    
    [self.view addSubview:_messageContent];
}

-(void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
