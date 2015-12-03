//
//  CJGroupMessageDataSource.m
//  artWorld
//
//  Created by 张晓旭 on 15/11/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJGroupMessageDataSource.h"
#import "CJMessageCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "MBProgressHUD+NJ.h"

@interface CJGroupMessageDataSource ()

{
    NSDictionary *groupDict;
}

@end

@implementation CJGroupMessageDataSource

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
    
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"circleNews",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             groupDict = [NSDictionary dictionaryWithDictionary:responseObject[@"info"]];
             
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"g_cell";
    CJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CJMessageCell" owner:nil options:nil] lastObject];
    }
    
    if (0 == indexPath.row)
    {
        cell.g_Image.image = [UIImage imageNamed:@"@"];
        cell.g_Items.text = @"@我";
        
        //未读消息设置
        NSString *messageStr = [NSString stringWithFormat:@"%@",[groupDict valueForKey:@"callMeUnreadNum"]];
        if ([messageStr integerValue] > 0)
        {
            cell.g_HintBtn.hidden = NO;
            [cell.g_HintBtn setTitle:messageStr forState:UIControlStateNormal];
        }
        else
        {
            cell.g_HintBtn.hidden = YES;
        }
    }
    else if(1 == indexPath.row)
    {
        cell.g_Image.image = [UIImage imageNamed:@"评论"];
        cell.g_Items.text = @"评论消息";
        
        //未读消息设置
        NSString *messageStr = [NSString stringWithFormat:@"%@",[groupDict valueForKey:@"commontUnreadNum"]];
        if ([messageStr integerValue] > 0)
        {
            cell.g_HintBtn.hidden = NO;
            [cell.g_HintBtn setTitle:messageStr forState:UIControlStateNormal];
        }
        else
        {
            cell.g_HintBtn.hidden = YES;
        }
    }
    else if(2 == indexPath.row)
    {
        cell.g_Image.image = [UIImage imageNamed:@"赞"];
        cell.g_Items.text = @"赞";
        
        //未读消息设置
        NSString *messageStr = [NSString stringWithFormat:@"%@",[groupDict valueForKey:@"goodUnreadNum"]];
        if ([messageStr integerValue] > 0)
        {
            cell.g_HintBtn.hidden = NO;
            [cell.g_HintBtn setTitle:messageStr forState:UIControlStateNormal];
        }
        else
        {
            cell.g_HintBtn.hidden = YES;
        }
    }
    else if(3 == indexPath.row)
    {
        cell.g_Image.image = [UIImage imageNamed:@"分享"];
        cell.g_Items.text = @"转发消息";
        
        //未读消息设置
        NSString *messageStr = [NSString stringWithFormat:@"%@",[groupDict valueForKey:@"fowardUnreadNum"]];
        if ([messageStr integerValue] > 0)
        {
            cell.g_HintBtn.hidden = NO;
            [cell.g_HintBtn setTitle:messageStr forState:UIControlStateNormal];
        }
        else
        {
            cell.g_HintBtn.hidden = YES;
        }
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        _toAtMe();
    }else if (indexPath.row == 1){
        _toCommentMessage();
    }else if (indexPath.row == 2){
        _toPraiseMe();
    }else if (indexPath.row == 3){
        _toForward();
    }
}

@end
