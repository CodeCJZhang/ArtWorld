//
//  CJForwardedMessageController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJForwardedMessageController.h"
#import "CJForwardedMessageCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "MBProgressHUD+NJ.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CJUtilityTools.h"

#define padding 8
#define padding1 10

@interface CJForwardedMessageController ()

{
    NSMutableArray *forwardArray;
}

//页码
@property (nonatomic,copy) NSString *pageNumber;

//数据总数量
@property (nonatomic,assign) NSInteger totalNumber;

@property (nonatomic,strong) CJForwardedMessageCell *cell;

@end

@implementation CJForwardedMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"转发消息";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick1)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _pageNumber = @"1";
    [self request];
}

//退出界面
-(void)backBtnClick1
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
    NSDictionary *JsonDic = @{@"param":@"getForwordDynamicByUser",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _totalNumber = [[responseObject[@"info"] valueForKey:@"totalNumber"] integerValue];
             NSArray *newArr = [NSArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             NSLog(@"请求结果:%@",responseObject);
             [self countCellHeightWithDataArrar:newArr];
             [self.tableView reloadData];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}

#pragma mark - 计算每行行高
-(void)countCellHeightWithDataArrar:(NSArray *)array
{
    forwardArray = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //当前行数据
        NSMutableDictionary *cellDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        //cell总高
        CGFloat sumH;
        //固定高度
        CGFloat fixedH = 100.0;
        
        //转发文字高度
        NSString *text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
        CGFloat textH = [CJUtilityTools countTextHeightWithString:text placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];
        
        //原文数据字典
        NSDictionary *ori_Dict = [NSDictionary dictionaryWithDictionary:[cellDict valueForKey:@"original_dynamic"]];
        
        //原文文字高度
        NSMutableString *at = [[NSMutableString alloc] initWithString:@"@:"];
        [at insertString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"nickname"]] atIndex:1];
        NSString *ori_text = [at stringByAppendingString:[CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"content"]]]];
        CGFloat ori_textH = [CJUtilityTools countTextHeightWithString:ori_text placeHolderWidth:(kSCREEN_WIDTH - padding * 4)];
        
        //计算总高度
        //一张图片高度
        CGFloat imageH = (kSCREEN_WIDTH - padding * 2 - padding1 * 4) / 3;
        NSInteger imageNum = [CJUtilityTools imageUrlArrWithUrlStr:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"clear_img"]]].count;
        if (imageNum == 0)
        {
            sumH = fixedH + textH + ori_textH;
        }
        else if (imageNum > 0 && imageNum < 4)
        {
            sumH = fixedH + textH + ori_textH + padding + imageH;
        }
        else if (imageNum > 3 && imageNum < 7)
        {
            sumH = fixedH + textH + ori_textH + (padding + imageH) * 2;
        }
        else if (imageNum > 6 && imageNum < 10)
        {
            sumH = fixedH + textH + ori_textH + (padding + imageH) * 3;
        }
        
        //把cell高度插入数组中
        NSNumber *cellH = [NSNumber numberWithFloat:sumH];
        [cellDict setObject:cellH forKey:@"cellHeight"];
        [forwardArray addObject:cellDict];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return forwardArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ForwardedMessage";
    CJForwardedMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CJForwardedMessageCell" owner:nil options:nil]firstObject];
    }
    
    //当前行数据
    NSDictionary *cellDict = [NSDictionary dictionaryWithDictionary:forwardArray[indexPath.row]];
    
    //头像
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"head_img"]]];
    [cell.icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
    
    //昵称
    cell.name.text = [NSString stringWithFormat:@"%@",[cellDict valueForKey:@"nickname"]];
    
    //认证
    NSInteger state = [[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"authentication_state"]] integerValue];
    if (state == 3)
    {
        cell.vip.hidden = NO;
    } else {
        cell.vip.hidden = YES;
    }
    
    //时间
    cell.time.text = [CJUtilityTools timeStampWithTimeStr:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"create_time"]]];
    
    //转发文字
    cell.content.text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
    
    //原文数据字典
    NSDictionary *ori_Dict = [NSDictionary dictionaryWithDictionary:[cellDict valueForKey:@"original_dynamic"]];
    
    //微博原文
    NSMutableString *at = [[NSMutableString alloc] initWithString:@"@:"];
    [at insertString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"nickname"]] atIndex:1];
    cell.ori_content.text = [at stringByAppendingString:[CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"content"]]]];
    
    //微博原图片集
    NSArray *imageArr = [NSArray arrayWithArray:[CJUtilityTools imageUrlArrWithUrlStr:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"clear_img"]]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    _cell = cell;
    [self designCellWithUrlArray:imageArr];
    
    return _cell;
}


#pragma mark - cell排版
-(void)designCellWithUrlArray:(NSArray *)array
{
    NSInteger imageCount = array.count;
    
    if (imageCount == 0)
    {
        _cell.bottomToWeibo.priority = 999;
        _cell.bottomToFirst.priority = 998;
        _cell.bottomToSecond.priority = 997;
        _cell.bottomToThird.priority = 996;
    }
    else if (imageCount > 0 && imageCount < 4)
    {
        _cell.bottomToWeibo.priority = 996;
        _cell.bottomToFirst.priority = 999;
        _cell.bottomToSecond.priority = 998;
        _cell.bottomToThird.priority = 997;
    }
    else if (imageCount > 3 && imageCount < 7)
    {
        _cell.bottomToWeibo.priority = 996;
        _cell.bottomToFirst.priority = 997;
        _cell.bottomToSecond.priority = 999;
        _cell.bottomToThird.priority = 998;
    }
    else if (imageCount > 6 && imageCount < 10)
    {
        _cell.bottomToWeibo.priority = 996;
        _cell.bottomToFirst.priority = 997;
        _cell.bottomToSecond.priority = 998;
        _cell.bottomToThird.priority = 999;
    }
    
    //隐藏无图片的button
    [_cell.imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = obj;
        if (idx < imageCount)
        {
            button.hidden = NO;
        }
        else
        {
            button.hidden = YES;
        }
    }];
    
    //为button附加图片
    if (imageCount > 0 && imageCount < 10)
    {
        for (NSInteger i = 0; i < imageCount; i++)
        {
            UIButton *btn = _cell.imageArray[i];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:array[i]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
        }
    }
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[forwardArray[indexPath.row] valueForKey:@"cellHeight"] floatValue];
}


@end
