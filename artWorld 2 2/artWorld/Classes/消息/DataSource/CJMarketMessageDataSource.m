//
//  CJMessageDataSouce.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/22.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJMarketMessageDataSource.h"
#import "CJMessageCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "MBProgressHUD+NJ.h"

@interface CJMarketMessageDataSource ()

//系统消息未读数量
@property (nonatomic,copy) NSString *sysMessageNum;

//最后系统消息
@property (nonatomic,copy) NSString *lastSysMessage;

//物流消息未读数量
@property (nonatomic,copy) NSString *logMessageNum;

//最后物流消息
@property (nonatomic,copy) NSString *lastLogMessage;

@end

@implementation CJMarketMessageDataSource

#pragma mark - 请求数据

-(id)init
{
    self = [super init];
    if (self)
    {
        [self request];
    }
    return self;
}

- (void)request
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    NSString *shop_state = [user objectForKey:@"shop_state"];
    
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"shop_state":shop_state};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"mallNews",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _sysMessageNum = [NSString stringWithFormat:@"%@",[responseObject[@"info"] valueForKey:@"systemMessageNumber"]];
             _lastSysMessage = [NSString stringWithFormat:@"%@",[responseObject[@"info"] valueForKey:@"systemMessageLastContent"]];
             _logMessageNum = [NSString stringWithFormat:@"%@",[responseObject[@"info"] valueForKey:@"flowMessageNumber"]];
             _lastLogMessage = [NSString stringWithFormat:@"%@",[responseObject[@"info"] valueForKey:@"flowMessageLastContent"]];
             
             NSLog(@"请求结果:%@",responseObject);
             
             [self.tableview reloadData];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"m_cell";
    CJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CJMessageCell" owner:nil options:nil] firstObject];
    }
    
    if (0 == indexPath.row)
    {
        //图片
        cell.m_image.image = [UIImage imageNamed:@"系统消息"];
        
        //未读消息设置
        if ([_sysMessageNum integerValue] > 0)
        {
            cell.m_hintBtn.hidden = NO;
            [cell.m_hintBtn setTitle:_sysMessageNum forState:UIControlStateNormal];
        }
        else
        {
            cell.m_hintBtn.hidden = YES;
        }
        
        //标题
        cell.m_items.text = @"系统消息";
        
        //最后消息
        if ([_lastSysMessage isEqualToString:@""])
        {
            cell.lastMessage.text = @"暂无新消息";
        } else {
            cell.lastMessage.text = _lastSysMessage;
        }
    }
    else if (indexPath.row == 1)
    {
        //图片
        cell.m_image.image = [UIImage imageNamed:@"物流助手"];
        
        //未读消息设置
        if ([_logMessageNum integerValue] > 0)
        {
            cell.m_hintBtn.hidden = NO;
            [cell.m_hintBtn setTitle:_logMessageNum forState:UIControlStateNormal];
        }
        else
        {
            cell.m_hintBtn.hidden = YES;
        }
        
        //标题
        cell.m_items.text = @"物流助手";
        
        //最后消息
        if ([_lastLogMessage isEqualToString:@""]) {
            cell.lastMessage.text = @"暂无新消息";
        } else {
            cell.lastMessage.text = _lastLogMessage;
        }
    }

    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        _toSystemMessage();
    }
    else if (indexPath.row == 1)
    {
        _toLogisticsHelper();
    }
}

@end
