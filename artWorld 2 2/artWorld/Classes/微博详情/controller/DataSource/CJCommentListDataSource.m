//
//  CJCommentListDataSource.m
//  artWorld
//
//  Created by 张晓旭 on 15/11/18.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJCommentListDataSource.h"
#import "CJAttachCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"

@interface CJCommentListDataSource ()

//行高
@property (nonatomic,assign) CGFloat cellH;

//页码
@property (nonatomic,copy) NSString *pageNumber;

//评论集合
@property (nonatomic,strong) NSMutableArray *commArr;

@end

@implementation CJCommentListDataSource

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
    NSLog(@"_weiBo_ID = %@",self.weiBo_ID);
    NSDictionary *fieldDic = @{@"id":self.weiBo_ID, @"pageSize":@"10", @"pageNumber":_pageNumber};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"getUserByDynamicRespond",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _commArr = [NSMutableArray arrayWithArray:[responseObject valueForKey:@"data"]];
             
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
    return _cellH;
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Attach";
    CJAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CJAttachCell" owner:nil options:nil] firstObject];
        
        _cellH = cell.cellHeight;
        //        [tableView reloadData];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

@end
