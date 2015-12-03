//
//  CJMoreArtContentController.m
//  artWorld
//
//  Created by 张晓旭 on 15/9/23.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "CJMoreArtContentController.h"
#import "CJWeiBoCell.h"
#import "CJWeiboDetailsController.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "AW_Constants.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD+NJ.h"

#define padding 8
#define padding1 10
#define CJTextFont [UIFont systemFontOfSize:15]

@interface CJMoreArtContentController ()

{
    NSMutableArray *ContentArr;
    
    NSMutableArray *urlArr;   //图片集
}

@property (nonatomic,strong) CJWeiBoCell *cell;


@end

@implementation CJMoreArtContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"艺圈内容";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    [self getArtContentData];
}


#pragma mark - popViewController
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求内容数据
-(void)getArtContentData
{
    //请求数据
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"pageSize":@"10", @"pageNumber":@"1", @"keyWord":_keyWord};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"searchDynamic",@"token":@"android",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             ContentArr = [NSMutableArray arrayWithArray:[responseObject[@"info"] valueForKey:@"data"]];
             
             //计算出每行高度
             [self countCellHeight];
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


#pragma mark - 计算行高
//遍历ContentArr数组，计算出每行高度并保存
-(void)countCellHeight
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:ContentArr.count];
    
    [ContentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         //遍历数组中元素
         NSMutableDictionary *celldict = [NSMutableDictionary dictionaryWithDictionary:obj];
         
         //cell高度
         CGFloat sumH;
         
         //判断类型
         NSString *original_Str = [celldict valueForKey:@"original_dynamic"];
         
         //原文模式
         if ([original_Str isKindOfClass:[NSNull class]])
         {
             //微博内容
             NSString *weibo = [NSString stringWithFormat:@"%@",[celldict valueForKey:@"content"]];
             CGFloat textH = [self countTextHeightWithString:weibo placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];
             
             //图片
             NSMutableArray *imgArr;
             NSString *images = [NSString stringWithFormat:@"%@",[celldict valueForKey:@"clear_img"]];
             if ([images isKindOfClass:[NSNull class]])
             {
                 imgArr = nil;
             }
             else
             {
                 NSArray *tempArr = [images componentsSeparatedByString:@","];
                 imgArr = [NSMutableArray arrayWithArray:tempArr];
                 NSInteger i = 1;
                 while (i)
                 {
                     if ([imgArr containsObject:@""])
                     {
                         [imgArr removeObject:@""];
                     }
                     else{
                         i = 0;
                     }
                 }
             }
             
             //计算cell高度
             //一张图片的高度
             CGFloat photoH = (kSCREEN_WIDTH - padding * 4) / 3;
             if ([weibo isKindOfClass:[NSNull class]])//没有正文的情况
             {
                 if (imgArr.count > 0 && imgArr.count < 4) //一行图片
                 {
                     sumH = photoH + 103 + padding * 3;
                 }
                 else if (imgArr.count > 3 && imgArr.count < 7) //两行图片
                 {
                     sumH = photoH * 2 + 103 + padding * 4;
                 }
                 else if (imgArr.count > 6 && imgArr.count < 10) //三行图片
                 {
                     sumH = photoH * 3 + 103 + padding * 5;
                 }
             }
             else //有正文的情况
             {
                 if (imgArr.count == 0)  //0行图片
                 {
                     sumH = textH + padding * 3 + 103;
                 }
                 else if(imgArr.count > 0 && imgArr.count < 4) //一行图片
                 {
                     sumH = textH + photoH + 103 + padding * 4;
                 }
                 else if (imgArr.count > 3 && imgArr.count < 7) //两行图片
                 {
                     sumH = textH + photoH * 2 + 103 + padding * 5;
                 }
                 else if (imgArr.count > 6 && imgArr.count < 10) //三行图片
                 {
                     sumH = textH + photoH * 3 + 103 + padding * 6;
                 }
             }
         }
         else   //转发模式
         {
             /**################## 转发区域 ##################*/
             //转发文字
             NSString *weibo = [NSString stringWithFormat:@"%@",[celldict valueForKey:@"content"]];
             CGFloat textH = [self countTextHeightWithString:weibo placeHolderWidth:(kSCREEN_WIDTH - padding * 2)];//此高度肯定存在
             
             /**################## 原文区域 ##################*/
             //原文数据
             NSDictionary *ori_dict = [NSDictionary dictionaryWithDictionary:[celldict valueForKey:@"original_dynamic"]];
             
             //原微博区域高度
             CGFloat oriH;
             //微博原文
             NSString *ori_weibo = [NSString stringWithFormat:@"%@",[ori_dict valueForKey:@"content"]];
             CGFloat ori_textH = [self countTextHeightWithString:ori_weibo placeHolderWidth:(kSCREEN_WIDTH - padding * 4)];  //此高度肯定存在
             
             //图片
             NSMutableArray *imgArr;
             NSString *images = [NSString stringWithFormat:@"%@",[ori_dict valueForKey:@"clear_img"]];
             if ([images isKindOfClass:[NSNull class]])
             {
                 imgArr = nil;
             }
             else
             {
                 NSArray *tempArr = [images componentsSeparatedByString:@","];
                 imgArr = [NSMutableArray arrayWithArray:tempArr];
                 NSInteger i = 1;
                 while (i)
                 {
                     if ([imgArr containsObject:@""])
                     {
                         [imgArr removeObject:@""];
                     }
                     else{
                         i = 0;
                     }
                 }
             }
             
             //计算cell高度
             //一张图片的高度
             CGFloat photoH = (kSCREEN_WIDTH - padding * 2 - padding1 * 4) / 3;
             
             if (imgArr.count == 0)  //0行图片
             {
                 oriH = ori_textH + padding * 2;
                 sumH = oriH + textH + 134;
             }
             else if (imgArr.count > 0 && imgArr.count < 4)   //1行图片
             {
                 oriH = ori_textH + photoH + padding * 3;
                 sumH = oriH + textH + 134;
             }
             else if (imgArr.count > 3 && imgArr.count < 7)  //2行图片
             {
                 oriH = ori_textH + photoH * 2 + padding * 4;
                 sumH = oriH + textH + 134;
             }
             else if (imgArr.count > 6 && imgArr.count < 10) //3行图片
             {
                 oriH = ori_textH + photoH * 3 + padding * 5;
                 sumH = oriH + textH + 134;
             }
         }
         
         //把cell高度插入数组中
         NSNumber *cellH = [NSNumber numberWithFloat:sumH];
         [celldict setObject:cellH forKey:@"cellHeight"];
         [tempArr addObject:celldict];
     }];
    
    [ContentArr removeAllObjects];
    ContentArr = [tempArr mutableCopy];
}

#pragma mark - 计算文字所占高度
-(CGFloat)countTextHeightWithString:(NSString *)string placeHolderWidth:(CGFloat)width
{
    NSDictionary *dict = @{NSFontAttributeName:CJTextFont};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    CGSize textSize = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    CGFloat textH = textSize.height;
    return textH;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ContentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出当前行数据
    NSDictionary *temp = [NSDictionary dictionaryWithDictionary:ContentArr[indexPath.row]];
    //动态类型
    NSString *original_Str = [temp valueForKey:@"original_dynamic"];
    
    //原文模式
    if ([original_Str isKindOfClass:[NSNull class]])
    {
        static NSString *identifier = @"art";
        CJWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CJWeiBoCell" owner:nil options:nil] firstObject];
        }
        
        //头像
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[temp valueForKey:@"head_img"]]];
        [cell.icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
        
        //昵称
        cell.name.text = [NSString stringWithFormat:@"%@",[temp valueForKey:@"nickname"]];
        
        //认证
        NSString *state = [NSString stringWithFormat:@"%@",[temp valueForKey:@"authentication_state"]];
        if ([state integerValue] == 3)
        {
            cell.vip.hidden = NO;
        } else {
            cell.vip.hidden = YES;
        }
        
        //签名
        cell.namedesc.text = [NSString stringWithFormat:@"%@",[temp valueForKey:@"signature"]];
        
        //正文
        NSString *content = [NSString stringWithFormat:@"%@",[temp valueForKey:@"content"]];
        
        //图片
        NSString *images = [NSString stringWithFormat:@"%@",[temp valueForKey:@"clear_img"]];
        if ([images isEqualToString:@"<null>"])
        {
            urlArr = nil;
        }
        else
        {
            NSArray *tempArr = [images componentsSeparatedByString:@","];
            urlArr = [NSMutableArray arrayWithArray:tempArr];
            NSInteger i = 1;
            while (i)
            {
                if ([urlArr containsObject:@""])
                {
                    [urlArr removeObject:@""];
                }
                else{
                    i = 0;
                }
            }
        }
        
        //时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        double timestamp = [[NSString stringWithFormat:@"%@",[temp valueForKey:@"create_time"]] doubleValue] / 1000;
        NSTimeInterval interval = timestamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSString *time = [formatter stringFromDate:date];
        cell.time.text = time;
        
        //地点
        NSString *add = [NSString stringWithFormat:@"%@",[temp valueForKey:@"location"]];
        if ([add isEqualToString:@"<null>"])
        {
            cell.address.hidden = YES;
        }
        else
        {
            cell.address.hidden = NO;
            [cell.address setTitle:add forState:UIControlStateNormal];
        }
        
        _cell = cell;
        
        [self hasText:content imageArray:urlArr];
    }
    //转发模式
    else
    {
        static NSString *identifier = @"art1";
        CJWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CJWeiBoCell" owner:nil options:nil] lastObject];
        }
        
        //头像
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[temp valueForKey:@"head_img"]]];
        [cell.s_icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
        
        //昵称
        cell.s_name.text = [NSString stringWithFormat:@"%@",[temp valueForKey:@"nickname"]];
        
        //认证
        NSString *state = [NSString stringWithFormat:@"%@",[temp valueForKey:@"authentication_state"]];
        if ([state integerValue] == 3)
        {
            cell.s_vip.hidden = NO;
        } else {
            cell.s_vip.hidden = YES;
        }
        
        //签名
        cell.s_signature.text = [NSString stringWithFormat:@"%@",[temp valueForKey:@"signature"]];
        
        //转发文字
        cell.s_weibo.text = [NSString stringWithFormat:@"%@",[temp valueForKey:@"content"]];
        
        //时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        double timestamp = [[NSString stringWithFormat:@"%@",[temp valueForKey:@"create_time"]] doubleValue] / 1000;
        NSTimeInterval interval = timestamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSString *time = [formatter stringFromDate:date];
        cell.s_time.text = time;
        
        //地址
        NSString *add = [NSString stringWithFormat:@"%@",[temp valueForKey:@"location"]];
        if ([add isEqualToString:@"<null>"])
        {
            cell.s_address.hidden = YES;
        }
        else
        {
            cell.s_address.hidden = NO;
            [cell.s_address setTitle:add forState:UIControlStateNormal];
        }
        
        //原文数据
        NSDictionary *ori_dict =[NSDictionary dictionaryWithDictionary:[temp valueForKey:@"original_dynamic"]];
        //原文
        _cell.ori_weibo.text = [NSString stringWithFormat:@"%@",[ori_dict valueForKey:@"content"]];
        
        //原文图片
        NSString *images = [NSString stringWithFormat:@"%@",[ori_dict valueForKey:@"clear_img"]];
        if ([images isEqualToString:@"<null>"])
        {
            urlArr = nil;
        }
        else
        {
            NSArray *tempArr = [images componentsSeparatedByString:@","];
            urlArr = [NSMutableArray arrayWithArray:tempArr];
            NSInteger i = 1;
            while (i)
            {
                if ([urlArr containsObject:@""])
                {
                    [urlArr removeObject:@""];
                }
                else{
                    i = 0;
                }
            }
        }
        
        _cell = cell;
        
        [self designCellWithPhotoArray:urlArr];
    }
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.preservesSuperviewLayoutMargins = NO;
    _cell.separatorInset = UIEdgeInsetsZero;
    _cell.layoutMargins = UIEdgeInsetsZero;
    
    return _cell;
}


#pragma mark - cell 布局排版

//转发模式
-(void)designCellWithPhotoArray:(NSArray *)photoArray
{
    NSInteger photoCount = photoArray.count;
    
    if (photoCount == 0)
    {
        _cell.supToLab.priority = 999;
        _cell.supToFirst.priority = 998;
        _cell.supToSecond.priority = 997;
        _cell.supToThird.priority = 996;
    }
    else if (photoCount > 0 && photoCount < 4)
    {
        _cell.supToLab.priority = 996;
        _cell.supToFirst.priority = 999;
        _cell.supToSecond.priority = 998;
        _cell.supToThird.priority = 997;
    }
    else if (photoCount > 3 && photoCount < 7)
    {
        _cell.supToLab.priority = 996;
        _cell.supToFirst.priority = 997;
        _cell.supToSecond.priority = 999;
        _cell.supToThird.priority = 998;
    }
    else if (photoCount > 6 && photoCount < 10)
    {
        _cell.supToLab.priority = 996;
        _cell.supToFirst.priority = 997;
        _cell.supToSecond.priority = 998;
        _cell.supToThird.priority = 999;
    }
    
    //隐藏无图片的button
    [_cell.ori_photo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = obj;
        if (idx < photoCount)
        {
            button.hidden = NO;
        }
        else
        {
            button.hidden = YES;
        }
    }];
    
    //为button附加图片
    if (photoCount > 0 && photoCount < 10)
    {
        for (NSInteger i = 0; i < photoCount; i++)
        {
            UIButton *btn = _cell.ori_photo[i];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:photoArray[i]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
        }
    }
}

//原文模式
-(void)hasText:(NSString*)text imageArray:(NSArray *)imageArray
{
    NSInteger imageCount = imageArray.count;
    
    if (text)
    {
        _cell.picturedesc.hidden = NO;
        _cell.picturedesc.text = text;
        _cell.picToWeibo.priority = 999;
        _cell.picToIcon.priority = 998;
    }
    else
    {
        _cell.picturedesc.hidden = YES;
        _cell.picToWeibo.priority = 998;
        _cell.picToIcon.priority = 999;
    }
    
    if (imageCount == 0)
    {
        _cell.timeToWeibo.priority = 999;
        _cell.timeToFirst.priority = 998;
        _cell.timeToSecond.priority = 997;
        _cell.timeToThird.priority = 996;
    }
    else if (imageCount > 0 && imageCount < 4)
    {
        _cell.timeToWeibo.priority = 996;
        _cell.timeToFirst.priority = 999;
        _cell.timeToSecond.priority = 998;
        _cell.timeToThird.priority = 997;
    }
    else if (imageCount > 3 && imageCount < 7)
    {
        _cell.timeToWeibo.priority = 996;
        _cell.timeToFirst.priority = 997;
        _cell.timeToSecond.priority = 999;
        _cell.timeToThird.priority = 998;
    }
    else if (imageCount > 6 && imageCount < 10)
    {
        _cell.timeToWeibo.priority = 996;
        _cell.timeToFirst.priority = 997;
        _cell.timeToSecond.priority = 998;
        _cell.timeToThird.priority = 999;
    }
    
    //隐藏无图片的button
    [_cell.imageArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
            UIButton *btn = _cell.imageArr[i];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArray[i]] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
        }
    }
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[ContentArr[indexPath.row] valueForKey:@"cellHeight"] floatValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
