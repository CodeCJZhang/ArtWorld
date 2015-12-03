//
//  CJMoreContactPersonController.m
//  artWorld
//
//  Created by 张晓旭 on 15/10/28.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJMoreContactPersonController.h"
#import "CJSearchCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD+NJ.h"

@interface CJMoreContactPersonController ()

{
    NSMutableArray *contactArr;
}

@end

@implementation CJMoreContactPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"联系人";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBtn;

    [self getContactData];
}

#pragma mark - 请求联系人数据

-(void)getContactData
{
    //请求数据
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"pageSize":@"20", @"pageNumber":@"1", @"keyWord":_keyWord};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"searchContacts",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             //总记录数
             NSInteger totalNumber = [[NSString stringWithFormat:@"%@",[responseObject[@"info"] valueForKey:@"totalNumber"]] integerValue];
             
             contactArr = [NSMutableArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             [self.tableView reloadData];
             NSLog(@"请求结果:%@",responseObject);
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

#pragma mark - popViewController
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"search";
    CJSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CJSearchCell" owner:nil options:nil][1];
    }
    //取出当前行数据
    NSDictionary *temp = [NSDictionary dictionaryWithDictionary:contactArr[indexPath.row]];
    
    //头像
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[temp valueForKey:@"head_img"]]];
    [cell.contactsIcon sd_setImageWithURL:iconUrl placeholderImage:PLACE_HOLDERIMAGE];
    
    //昵称
    NSString *name = [NSString stringWithFormat:@"%@",[temp valueForKey:@"nickname"]];
    cell.contactsName.text = name;
    
    //认证
    NSString *state = [NSString stringWithFormat:@"%@",[temp valueForKey:@"authentication_state"]];
    if ([state integerValue] == 3)
    {
        cell.vip.hidden = NO;
    }
    else
    {
        cell.vip.hidden = YES;
    }
    
    //关注
    NSString *attention = [NSString stringWithFormat:@"%@",[temp valueForKey:@"isAttended"]];
    if ([attention boolValue] == YES)
    {
        [cell.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    else
    {
        [cell.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

@end
