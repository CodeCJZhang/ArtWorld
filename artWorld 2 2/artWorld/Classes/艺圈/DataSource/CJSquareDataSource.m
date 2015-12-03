//  CJTableViewDataSouce.m
//  artWorld
//
//  Created by 张晓旭 on 15/8/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJSquareDataSource.h"
#import "CJWeiBoCell.h"
#import "AFNetworking.h"
#import "CJCellParameter.h"
#import "IMB_Macro.h"
#import "MBProgressHUD+NJ.h"
#import "IMB_TableDataSource.h"

#define CJTextFont [UIFont systemFontOfSize:15]
#define padding 8
#define padding1 10

//#import "AW_MyDynamicblogCell.h"    //没用到
//allEmoji  表情转换 

@interface CJSquareDataSource ()

{
    NSMutableArray *square;
}

//微博总条数
@property (nonatomic,copy) NSString *totalNumber;

//页码
@property (nonatomic,copy) NSString *pageNumber;

//cell
@property (nonatomic,strong) CJWeiBoCell *cell;

@end

@implementation CJSquareDataSource


#pragma mark - 请求数据

-(id)init {
    self = [super init];
    if (self) {
        _pageNumber = @"1";
        square = [[NSMutableArray alloc] init];
        [self request];
    }
    return self;
}

- (void)request {
    //接口数据：
    NSDictionary *fieldDic = @{@"userId":@"", @"pageSize":@"10", @"pageNumber":_pageNumber, @"type":@"0"};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"dynamicList",@"token":@"",@"jsonParam":str};
    NSLog(@"str = %@",str);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             //微博总条数
             self.totalNumber = [responseObject[@"info"] valueForKey:@"totalNumber"];
             //当前页的微博数据
             square = [NSMutableArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             //保存开店状态
             
//             [NSString stringWithFormat:@"%@",[]];
             
             //遍历square数组，并计算出每行高度
             [self count4CellHeight];
             
             //刷新列表
             [self.tableView reloadData];
             
             NSLog(@"square = %@", square);
             NSLog(@"请求结果:%@",responseObject);
         }
     }
     failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

-(void)count4CellHeight
{
    //临时数组
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:square.count];
    
    [square enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict_data = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        //总高
        CGFloat sumH;
        
        //根据dict中的数据计算高度
            //原文模式
        if ([[dict_data valueForKey:@"original_dynamic"] isKindOfClass:[NSNull class]])
        {
            //微博正文高度
            NSDictionary *dict = @{NSFontAttributeName:CJTextFont};
            CGSize maxSize = CGSizeMake(kSCREEN_WIDTH - padding * 2, MAXFLOAT);
            CGSize textSize = [[dict_data valueForKey:@"content"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            CGFloat textH = textSize.height;
            
            //图片区高度
            NSArray *arr = [[dict_data valueForKey:@"clear_img"]componentsSeparatedByString:@","];
            CGFloat imgSumH;
            if (arr.count == 0)
            {
                imgSumH = 0;
            }
            else if (arr.count > 0 && arr.count <4)
            {
                imgSumH = (kSCREEN_WIDTH - padding * 4) / 3;
            }
            else if (arr.count > 3 && arr.count <7)
            {
                imgSumH = (kSCREEN_WIDTH - padding * 4) / 3 * 2 + padding;
            }
            else if (arr.count > 6 && arr.count <10)
            {
                imgSumH = kSCREEN_WIDTH - padding * 2;
            }
            
            //总高
            sumH = 135 + imgSumH + textH;
        }
        else    //转发模式
        {
            //转发文字高度
            NSDictionary *dict = @{NSFontAttributeName:CJTextFont};
            CGSize maxSize = CGSizeMake(kSCREEN_WIDTH - padding * 2, MAXFLOAT);
            CGSize textSize = [[dict_data valueForKey:@"content"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            CGFloat textH = textSize.height;
            
            //原微博区高度
            NSDictionary *ori_dict = [dict_data valueForKey:@"original_dynamic"];
             //原微博区文字高度
            CGSize ori_maxSize = CGSizeMake(kSCREEN_WIDTH - padding * 4, MAXFLOAT);
            CGSize ori_textSize = [[ori_dict valueForKey:@"content"] boundingRectWithSize:ori_maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            CGFloat ori_textH = ori_textSize.height;
            
             //原微博区图片总高度
            NSArray *arr = [[ori_dict valueForKey:@"clear_img"] componentsSeparatedByString:@","];
            CGFloat imgSumH;
            if (arr.count == 0)
            {
                imgSumH = 0;
            }
            else if (arr.count > 0 && arr.count < 4)
            {
                imgSumH = (kSCREEN_WIDTH - padding1 * 4 - padding * 2) / 3;
            }
            else if (arr.count > 3 && arr.count < 7)
            {
                imgSumH = (kSCREEN_WIDTH - padding1 * 4 - padding * 2) / 3 * 2 + padding;
            }
            else if (arr.count > 6 && arr.count < 10)
            {
                imgSumH = kSCREEN_WIDTH - padding1 * 4;
            }
            
            //原微博区总高
            CGFloat ori_sumH = ori_textH + padding * 3 + imgSumH;
            
            //总高
            sumH = 134 + textH + ori_sumH;
        }
        
        //当前行数据中插入cellHeight键值对
        NSNumber *cellH = [NSNumber numberWithFloat:sumH];
        [dict_data setObject:cellH forKey:@"cellHeight"];
        
        //把处理过的数据元素临时保存在tempArr
        [tempArr addObject:dict_data];
    }];
    //dict_data替换square中对应行元素
    [square removeAllObjects];
    square = [tempArr mutableCopy];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"square.count = %zd",square.count);
    if (square.count == 0)
    {
        return 0;
    }
    else
    {
        return square.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:square[indexPath.row]];
    
    CJCellParameter *cellParameter = [[CJCellParameter alloc]init];
    
    //给cellParameter模型赋接口中的数据
    cellParameter.weibo_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    cellParameter.iconImage = [NSString stringWithFormat:@"%@",[dict valueForKey:@"head_img"]];
    cellParameter.name = [NSString stringWithFormat:@"%@",[dict valueForKey:@"nickname"]];
    cellParameter.isVIP = [[dict valueForKey:@"authentication_state"] integerValue];
    cellParameter.shopState = [[dict valueForKey:@"shop_state"] integerValue];
    cellParameter.nameDesc = [NSString stringWithFormat:@"%@",[dict valueForKey:@"signature"]];
    cellParameter.pictureDesc = [NSString stringWithFormat:@"%@",[dict valueForKey:@"content"]];
    cellParameter.clearImages = [NSString stringWithFormat:@"%@",[dict valueForKey:@"clear_img"]];
    cellParameter.fuzzyImages = [NSString stringWithFormat:@"%@",[dict valueForKey:@"fuzzy_img"]];
    cellParameter.time = [NSString stringWithFormat:@"%@",[dict valueForKey:@"create_time"]];
    cellParameter.address = [NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]];
    cellParameter.isPraised = [NSString stringWithFormat:@"%@",[dict valueForKey:@"isPraised"]];
    cellParameter.original_dict = [dict valueForKey:@"original_dynamic"];
    
    static NSString *identifier = @"art";
    static NSString *identifier1 = @"art1";
    
    if ([[dict valueForKey:@"original_dynamic"] isKindOfClass:[NSNull class]])//原文模式
    {
        CJWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[CJWeiBoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell = [cell createCellWithParameter:cellParameter];
        
        cell.didclickBtn = ^(NSInteger index)
        {
            if (_artBlock)
            {
                _artBlock(index);
            }
        };
        _cell = cell;
    }
    else    //转发模式
    {
        CJWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell)
        {
            cell = [[CJWeiBoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        cell = [cell createCellWithParameter:cellParameter];

        cell.didclickBtn = ^(NSInteger index)
        {
            if (_artBlock)
            {
                _artBlock(index);
            }
        };
        _cell = cell;
    }
    
    //cell行不可点
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return _cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (square.count == 0)
    {
        return 0;
    }
    else
    {
        return [[square[indexPath.row] valueForKey:@"cellHeight"] floatValue];
    }
}

//行点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"weiBo_ID ＝ %@", [square[indexPath.row] valueForKey:@"id"]);
    _toWeiboDetails([square[indexPath.row] valueForKey:@"id"]);
}

@end
