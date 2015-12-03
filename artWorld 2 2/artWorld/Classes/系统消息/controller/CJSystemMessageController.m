//
//  CJSystemMessageModel1.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJSystemMessageController.h"
#import "CJSystemMessageCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "MBProgressHUD+NJ.h"
#import "CJSysMessageDetailsController.h"


@interface CJSystemMessageController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *systemMessageArr;
}

//页码
@property (nonatomic,copy) NSString *pageNum;

//总消息数量
@property (nonatomic,assign) NSInteger totalNumber;

//消息id
@property (nonatomic,copy) NSString *messageID;

@end

@implementation CJSystemMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统消息";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    _pageNum = @"1";
    [self request];
}

//退出界面
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//请求数据
- (void)request
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    NSString *shop_state = [user objectForKey:@"shop_state"];
    
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"shop_state":shop_state, @"pageSize":@"10", @"pageNumber":_pageNum};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"systemNews",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _totalNumber = [[responseObject[@"info"] valueForKey:@"totalNumber"] integerValue];
             systemMessageArr = [NSArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             NSLog(@"请求结果:%@",responseObject);
             [self.tableView reloadData];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return systemMessageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"system";
    CJSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CJSystemMessageCell" owner:nil options:nil] firstObject];
    }
    
    //取出当前行数据
    NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:systemMessageArr[indexPath.row]];
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    double timestamp = [[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"create_time"]] floatValue] / 1000;
    NSTimeInterval interval = timestamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *time = [formatter stringFromDate:date];
    [cell.time setTitle:time forState:UIControlStateNormal];
    
    //消息标题
    cell.item.text = [NSString stringWithFormat:@"%@",[tempDict valueForKey:@"title"]];
    
    //消息简要
    cell.desc.text = [NSString stringWithFormat:@"%@",[tempDict valueForKey:@"content"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 152;
}

//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJSysMessageDetailsController *smd = [[CJSysMessageDetailsController alloc]init];
    smd.message_ID = [NSString stringWithFormat:@"%@",[systemMessageArr[indexPath.row] valueForKey:@"id"]];
    [self.navigationController pushViewController:smd animated:YES];
}

@end
