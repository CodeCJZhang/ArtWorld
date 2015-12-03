//
//  CJAttachViewDataSource.m
//  artWorld
//
//  Created by 张晓旭 on 15/11/7.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJSendListDataSource.h"
#import "CJAttachCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"

@interface CJSendListDataSource ()

//行高
@property (nonatomic,assign) CGFloat cellHeight;

//页码
@property (nonatomic,copy) NSString *pageNumber;

//转发集合
@property (nonatomic,strong) NSMutableArray *sendArr;

@end

@implementation CJSendListDataSource


-(id)init {
    self = [super init];
    if (self) {
        _pageNumber = @"1";
    }
    return self;
}

#pragma mark - 请求数据

-(void)getData
{
    //借口数据：
    NSDictionary *fieldDic = @{@"id":self.weiBo_ID, @"pageSize":@"10", @"pageNumber":_pageNumber};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"getUserByDynamicForward",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _sendArr = [NSMutableArray arrayWithArray:[responseObject valueForKey:@"data"]];
             
             [self count4CellH];
             NSLog(@"请求结果:%@",responseObject);
             [self.tableView reloadData];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"错误提示：%@",error);
     }];
}

//计算行高
-(void)count4CellH
{

}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sendArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Attach";
    CJAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CJAttachCell" owner:nil options:nil] firstObject];
        
        _cellHeight = cell.cellHeight;
//        [tableView reloadData];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}


@end
