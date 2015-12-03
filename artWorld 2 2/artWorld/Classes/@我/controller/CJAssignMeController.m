//
//  CJAssignMeController.m
//  artWorld
//
//  Created by 张晓旭 on 15/11/28.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "CJAssignMeController.h"
#import "CJAssignMeCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "MBProgressHUD+NJ.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CJUtilityTools.h"


#define padding 8


@interface CJAssignMeController ()

{
    //数据列表集合
    NSMutableArray *atMeArr;
    
}

//页码
@property (nonatomic,copy) NSString *pageNumber;

//信息总条数
@property (nonatomic,assign) NSInteger totalNumber;

@property (nonatomic,strong) CJAssignMeCell *cell;

@end

@implementation CJAssignMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"@我";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick1)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _pageNumber = @"1";
    [self request];
}

//退出界面
-(void)backClick1
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
    NSDictionary *JsonDic = @{@"param":@"getDynamicByCall",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             _totalNumber = [[responseObject[@"info"] valueForKey:@"totalNumber"] integerValue];
             NSArray *newArr = [NSArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             NSLog(@"请求结果:%@",responseObject);
             [self countCellHeightWithArray:newArr];
             [self.tableView reloadData];
         }
     }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [MBProgressHUD showError:@"未获取到后台数据"];
         NSLog(@"错误提示：%@",error);
     }];
}


#pragma mark - cell高度计算
-(void)countCellHeightWithArray:(NSArray *)array
{
    atMeArr = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //当前行数据字典
        NSMutableDictionary *cellDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        //cell高度
        CGFloat sumH;
        //固定高度
        CGFloat fixed1H = 76.0;  //原文模式
        CGFloat fixed2H = 100.0; //转发模式
        
        //判断类型
        //原文模式
        if ([[cellDict valueForKey:@"original_dynamic"] isKindOfClass:[NSNull class]])
        {
            //计算文字高度
            NSString *text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
            CGFloat textH = [CJUtilityTools countTextHeightWithString:text placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];
            
            //计算cell高度
            //一张图片的高度
            CGFloat photoH = (kSCREEN_WIDTH - padding * 4) / 3;
            NSInteger photoNum = [CJUtilityTools imageUrlArrWithUrlStr:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"clear_img"]]].count;
            if (photoNum == 0)
            {
                sumH = fixed1H + textH;
            }
            else if (photoNum > 0 && photoNum < 4)
            {
                sumH = fixed1H + textH + padding + photoH;
            }
            else if (photoNum > 3 && photoNum < 7)
            {
                sumH = fixed1H + textH + (padding + photoH) * 2;
            }
            else if (photoNum > 6 && photoNum < 10)
            {
                sumH = fixed1H + textH + (padding + photoH) * 3;
            }
        }
        else    //转发模式
        {
            //计算文字高度
            NSString *text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
            CGFloat textH = [CJUtilityTools countTextHeightWithString:text placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];
            
            //原文数据字典
            NSDictionary *ori_Dict = [NSDictionary dictionaryWithDictionary:[cellDict valueForKey:@"original_dynamic"]];
            //计算原文高度
            NSMutableString *ori_text = [[NSMutableString alloc] initWithString:@"@:"];
            NSString *nickname = [NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"nickname"]];
            NSString *content = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"content"]]];
            [ori_text insertString:nickname atIndex:1];
            [ori_text appendString:content];
            CGFloat ori_textH = [CJUtilityTools countTextHeightWithString:ori_text placeHolderWidth:(kSCREEN_WIDTH - padding * 4)];
            
            sumH = textH + ori_textH + fixed2H;
        }
        //把cell高度插入数组中
        NSNumber *cellH = [NSNumber numberWithFloat:sumH];
        [cellDict setObject:cellH forKey:@"cellHeight"];
        [atMeArr addObject:cellDict];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return atMeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前行数据
    NSDictionary *cellDict = [NSDictionary dictionaryWithDictionary:atMeArr[indexPath.row]];

    //原文模式
    if ([[cellDict valueForKey:@"original_dynamic"] isKindOfClass:[NSNull class]])
    {
        static NSString *identifier = @"AssignMe";
        CJAssignMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CJAssignMeCell" owner:nil options:nil] firstObject];
        }
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
        cell.time.text = [CJUtilityTools timeStampWithTimeStr:[cellDict valueForKey:@"create_time"]];
        
        //微博简要
        cell.content.text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
        
        //图片集
        NSMutableArray *imageUrlArr = [NSMutableArray arrayWithArray:[CJUtilityTools imageUrlArrWithUrlStr:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"clear_img"]]]];
        
        _cell = cell;
        [self designCellWithPhotoArray:imageUrlArr];
    }
    else //转发模式
    {
        static NSString *identifier = @"AssignMe1";
        CJAssignMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CJAssignMeCell" owner:nil options:nil] lastObject];
        }
        //头像
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"head_img"]]];
        [cell.s_icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
        
        //昵称
        cell.s_name.text = [NSString stringWithFormat:@"%@",[cellDict valueForKey:@"nickname"]];
        
        //认证
        NSInteger state = [[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"authentication_state"]] integerValue];
        if (state == 3)
        {
            cell.s_vip.hidden = NO;
        } else {
            cell.s_vip.hidden = YES;
        }
        
        //时间
        cell.s_time.text = [CJUtilityTools timeStampWithTimeStr:[cellDict valueForKey:@"create_time"]];
        
        //微博简介
        cell.s_content.text = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[cellDict valueForKey:@"content"]]];
        
        //原文数据字典
        NSDictionary *ori_Dict = [NSDictionary dictionaryWithDictionary:[cellDict valueForKey:@"original_dynamic"]];
        
        //原文
        NSMutableString *ori_text = [[NSMutableString alloc] initWithString:@"@:"];
        NSString *nickname = [NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"nickname"]];
        NSString *content = [CJUtilityTools convertToViewableWithString:[NSString stringWithFormat:@"%@",[ori_Dict valueForKey:@"content"]]];
        [ori_text insertString:nickname atIndex:1];
        [ori_text appendString:content];
        
        cell.ori_content.text = ori_text;
        
        _cell = cell;
    }
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.preservesSuperviewLayoutMargins = NO;
    _cell.separatorInset = UIEdgeInsetsZero;
    _cell.layoutMargins = UIEdgeInsetsZero;
    
    return _cell;
}


//界面排版
-(void)designCellWithPhotoArray:(NSArray *)imageArray
{
    NSInteger imageCount = imageArray.count;
    
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
        _cell.bottomToFirst.priority = 998;
        _cell.bottomToSecond.priority = 999;
        _cell.bottomToThird.priority = 997;
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
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArray[i]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
        }
    }
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[atMeArr[indexPath.row] valueForKey:@"cellHeight"] floatValue];
}

@end
