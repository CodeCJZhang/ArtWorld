//
//  CJLogisticsHelperController.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJLogisticsHelperController.h"
#import "CJLogisticsHelperCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "MBProgressHUD+NJ.h"
#import "UIImageView+WebCache.h"
#import "CJUtilityTools.h"
#import "CJLogisticsDetailsController.h"


@interface CJLogisticsHelperController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *logisticsMessageArr;
}

//页码
@property (nonatomic,copy) NSString *pageNumber;

//信息总条数
@property (nonatomic,assign) NSInteger totalNumber;

@end

@implementation CJLogisticsHelperController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流助手";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    _pageNumber = @"1";
    
    [self request];
}

//退出界面
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)request
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    
    NSDictionary *fieldDic = @{@"userId":user_id, @"pageSize":@"10", @"pageNumber":_pageNumber};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"logisticsNews",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _totalNumber = [[responseObject[@"info"] valueForKey:@"totalNumber"] integerValue];
             logisticsMessageArr = [NSArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
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
    return logisticsMessageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"logistics";
    CJLogisticsHelperCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CJLogisticsHelperCell" owner:nil options:nil]firstObject];
    }
    
    //当前行数据
    NSDictionary *cellDict = [NSDictionary dictionaryWithDictionary:logisticsMessageArr[indexPath.row]];
    
    //时间
    [cell.time setTitle:[CJUtilityTools timeStampWithTimeStr:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"create_time"]]] forState:UIControlStateNormal];
    
    //标题
    cell.title.text = [NSString stringWithFormat:@"%@",[cellDict valueForKey:@"title"]];
    
    //图片
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"clear_img"]]];
    [cell.image sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
    
    //消息简要
    cell.content.text = [NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188;
}

//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJLogisticsDetailsController *ldc = [[CJLogisticsDetailsController alloc]init];
    ldc.newsId = [NSString stringWithFormat:@"%@",[logisticsMessageArr[indexPath.row] valueForKey:@"id"]];
    ldc.orderId = [NSString stringWithFormat:@"%@",[logisticsMessageArr[indexPath.row] valueForKey:@"order_id"]];
    
    [self.navigationController pushViewController:ldc animated:YES];
}

@end
