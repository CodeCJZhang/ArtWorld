//
//  CJFriendsDataSource.m
//  artWorld
//
//  Created by 张晓旭 on 15/11/16.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJFriendsDataSource.h"
#import "CJWeiBoCell.h"
#import "CJWeiboDetailsController.h"
#import "AFNetworking.h"
#import "CJCellParameter.h"
#import "IMB_Macro.h"
#import "MBProgressHUD+NJ.h"

@interface CJFriendsDataSource ()

{
    NSMutableArray *friends;
}

//微博总条数
@property (nonatomic,copy) NSString *totalNumber;

//页码
@property (nonatomic,copy) NSString *pageNumber;

@end

@implementation CJFriendsDataSource

#pragma mark - 请求数据

-(id)init
{
    self = [super init];
    if (self)
    {
        _pageNumber = @"1";
        friends = [[NSMutableArray alloc]init];
//        [self request];
    }
    return self;
}

- (void)request
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"pageSize":@"10", @"pageNumber":_pageNumber, @"type":@"1"};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"dynamicList",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             self.totalNumber = [responseObject[@"info"] valueForKey:@"totalNumber"];
             NSArray *dataArr = [responseObject[@"info"] valueForKey:@"data"];
             friends = [dataArr copy];
             
             NSLog(@"请求结果:%@",responseObject);
             
//             [self.tableView reloadData];
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
    static NSString *identifier = @"art";
    CJWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        CJCellParameter *cellParameter = [[CJCellParameter alloc]init];
        cellParameter.iconImage = [friends[indexPath.row] valueForKey:@"head_img"];
        cellParameter.name = [friends[indexPath.row] valueForKey:@"nickname"];
        cellParameter.isVIP = [[friends[indexPath.row] valueForKey:@"authentication_state"] integerValue];
        cellParameter.nameDesc = [friends[indexPath.row] valueForKey:@"signature"];
        cellParameter.pictureDesc = [friends[indexPath.row] valueForKey:@"content"];
        cellParameter.clearImages = [friends[indexPath.row] valueForKey:@"clear_img"];
        cellParameter.time = [friends[indexPath.row] valueForKey:@"create_time"];
        cellParameter.address = [friends[indexPath.row] valueForKey:@"location"];
        
        cell = [[CJWeiBoCell alloc]init];
        cell = [cell createCellWithParameter:cellParameter];
    }
    
    cell.didclickBtn = ^(NSInteger index)
    {
        if (_friBlock) {
            _friBlock(index);
        }
    };
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return friends.count;
    return 0;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJWeiboDetailsController *dc = [self.vc.storyboard instantiateViewControllerWithIdentifier:@"CJWeiboDetailsNC"];
    
    [_vc presentViewController:dc animated:YES completion:^{
    }];
}

@end
