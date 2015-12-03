//
//  ArtGroupCell.m
//  artWorld/Users/zhangxiaoxu/Documents/artWorld/artWorld/ArtSquareCell.h
//
//  Created by 张晓旭 on 15/8/7.
//  Copyright (c) 2015年 All rights reserved.
//

#import "CJWeiBoCell.h"
#import "AFNetworking.h"
#import "IMB_Macro.h"
#import "CJCellParameter.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AW_Constants.h"

@interface CJWeiBoCell ()

//cell模型
@property (nonatomic,strong) CJWeiBoCell *cell;

//原微博ID
@property (nonatomic,copy) NSString *weiBo_ID;

//转发微博ID
@property (nonatomic,copy) NSString *s_weiBoID;

//图片集
@property (nonatomic,strong) NSMutableArray *urlArray;

@end

@implementation CJWeiBoCell




- (void)awakeFromNib
{
    //隐藏进入小店的按钮（模型设计没有此按钮）
    self.enterBtn.hidden = YES;

    _bottom4Btn.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] CGColor];
    _bottom4Btn.layer.borderWidth = 1.0;
    
    _bottomView4Btn.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] CGColor];
    _bottomView4Btn.layer.borderWidth = 1.0;
}


#pragma mark - cell数据模型封装 createCellWithParameter:

-(CJWeiBoCell *)createCellWithParameter:(CJCellParameter *)cellParameter
{
    NSLog(@"cellParameter.original_data = %@",cellParameter.original_dict);
        /**#####################⬇️  原文状态  ⬇️#####################*/
    if ([cellParameter.original_dict isKindOfClass:[NSNull class]])
    {
        CJWeiBoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CJWeiBoCell" owner:nil options:nil] firstObject];
        
        //保存微博ID
        cell.weiBo_ID = cellParameter.weibo_id;
        
        //设置头像数据
        NSURL *url = [NSURL URLWithString:cellParameter.iconImage];
        [cell.icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
        
        //设置昵称
        cell.name.text = cellParameter.name;
        
        //设置VIP
        if (cellParameter.isVIP == 3)
        {
            cell.vip.hidden = NO;
        }
        else
        {
            cell.vip.hidden = YES;
        }
        
        //设置昵称简介数据
        cell.namedesc.text = cellParameter.nameDesc;
        
        //设置作品简介
        cell.picturedesc.text = cellParameter.pictureDesc;
        
        //设置时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        double timestamp = [cellParameter.time doubleValue] / 1000;
        NSTimeInterval interval = timestamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSString *time = [formatter stringFromDate:date];
        cell.time.text = time;
        
        //设置作品图片
        if (cellParameter.clearImages.length != 0)
        {
            NSLog(@"cellParameter.images = %@",cellParameter.clearImages);
            NSArray *tempArr = [cellParameter.clearImages componentsSeparatedByString:@","];
            cell.urlArray = [NSMutableArray arrayWithArray:tempArr];
            NSInteger i = 1;
            while (i)
            {
                if ([cell.urlArray containsObject:@""])
                {
                    [cell.urlArray removeObject:@""];
                }
                else{
                    i = 0;
                }
            }
            NSLog(@"cell.urlArray = %@",cell.urlArray);
        }
        else
        {
            cell.urlArray = nil;
        }
        //设置发布地址
        if ([cellParameter.address isKindOfClass:[NSNull class]])
        {
            cell.address.hidden = NO;
        }
        else
        {
            cell.address.hidden = YES;
            [cell.address setTitle:cellParameter.address forState:UIControlStateNormal];
        }
        
        _cell = cell;
        //排版、赋值
        [self hasText:_cell.picturedesc.text imageArray:_cell.urlArray];
        
        return _cell;
    }
    else      /**###################⬇️  转发微博状态  ⬇️####################*/
    {
        CJWeiBoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CJWeiBoCell" owner:nil options:nil] lastObject];
        
        //保存微博ID
        NSLog(@"cell.s_weiBoID = %@",cellParameter.weibo_id);
        cell.s_weiBoID = cellParameter.weibo_id;
        
        //设置头像数据
        NSURL *url = [NSURL URLWithString:cellParameter.iconImage];
        [cell.s_icon sd_setImageWithURL:url placeholderImage:PLACE_HOLDERIMAGE];
        
        //设置昵称
        cell.s_name.text = cellParameter.name;
        
        //设置VIP
        if (cellParameter.isVIP == 3)
        {
            cell.s_vip.hidden = NO;
        }
        else
        {
            cell.s_vip.hidden = YES;
        }
        
        //设置签名数据
        cell.s_signature.text = cellParameter.nameDesc;
        
        //设置正文
        cell.s_weibo.text = cellParameter.pictureDesc;
        
        //设置时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        double timestamp = [cellParameter.time doubleValue] / 1000;
        NSTimeInterval interval = timestamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSString *time = [formatter stringFromDate:date];
        cell.s_time.text = time;
        
        //设置发布地址
        if ([cellParameter.address isKindOfClass:[NSNull class]])
        {
            cell.s_address.hidden = NO;
        }
        else
        {
            cell.s_address.hidden = YES;
            [cell.s_address setTitle:cellParameter.address forState:UIControlStateNormal];
        }
        
        //原微博数据
        NSDictionary *ori_data = cellParameter.original_dict;
        
        //原微博正文
        cell.ori_weibo.text = [ori_data valueForKey:@"content"];
        
        //原微博图片集
        NSString *imgStr = [ori_data valueForKey:@"clear_img"];
        if (imgStr.length != 0)
        {
            NSArray *tempArr = [imgStr componentsSeparatedByString:@","];
            cell.urlArray = [NSMutableArray arrayWithArray:tempArr];
            NSInteger i = 1;
            while (i)
            {
                if ([cell.urlArray containsObject:@""])
                {
                    [cell.urlArray removeObject:@""];
                }
                else{
                    i = 0;
                }
            }
        }
        else
        {
            cell.urlArray = nil;
        }
        
        _cell = cell;
        //排版、赋值
        [self designWithPhotoArray:_cell.urlArray];
        
        return _cell;
    }
    return nil;
}


#pragma mark - cell的界面排版

//转发微博模式
-(void)designWithPhotoArray:(NSArray *)photoArray
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
        _cell.supToFirst.priority = 999;
        _cell.supToSecond.priority = 998;
        _cell.supToThird.priority = 887;
        _cell.supToLab.priority = 996;
    }
    else if (photoCount > 3 && photoCount < 7)
    {
        _cell.supToSecond.priority = 999;
        _cell.supToThird.priority = 998;
        _cell.supToFirst.priority = 997;
        _cell.supToLab.priority = 996;
    }
    else if (photoCount > 6 && photoCount < 10)
    {
        _cell.supToThird.priority = 999;
        _cell.supToSecond.priority = 998;
        _cell.supToFirst.priority = 997;
        _cell.supToLab.priority = 996;
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

//原版微博模式
-(void)hasText:(NSString*)text imageArray:(NSArray *)imageArray
{
    NSInteger imageCount = imageArray.count;
    if (text)
    {
        _cell.picturedesc.hidden = NO;
        _cell.picToWeibo.priority = 999;
        _cell.picToIcon.priority = 998;
    }
    else
    {
        _cell.picturedesc.hidden = YES;
        _cell.picToIcon.priority = 999;
        _cell.picToWeibo.priority = 998;
    }
    
    if (imageCount > 0 && imageCount < 4)
    {
        _cell.timeToFirst.priority = 999;
        _cell.timeToSecond.priority = 998;
        _cell.timeToThird.priority = 997;
        _cell.timeToWeibo.priority = 996;
    }
    else if (imageCount > 3 && imageCount < 7)
    {
        _cell.timeToSecond.priority = 999;
        _cell.timeToThird.priority = 998;
        _cell.timeToFirst.priority = 997;
        _cell.timeToWeibo.priority = 996;
    }
    else if (imageCount >6 && imageCount < 10)
    {
        _cell.timeToThird.priority = 999;
        _cell.timeToSecond.priority = 998;
        _cell.timeToFirst.priority = 997;
        _cell.timeToWeibo.priority = 996;
    }
    else if (imageCount == 0)
    {
        _cell.timeToWeibo.priority = 999;
        _cell.timeToFirst.priority = 998;
        _cell.timeToSecond.priority = 997;
        _cell.timeToThird.priority = 996;
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


#pragma mark - IBAction - BtnClick

//进入小店btn
- (IBAction)enter_btn:(UIButton *)sender
{
    
}

//图片点击
- (IBAction)imageBtnClick:(id)sender
{
    
}

//转发btn
- (IBAction)send_btn:(UIButton *)sender
{
    _index = sender.tag;
    if (_didclickBtn)
    {
        _didclickBtn(_index);
    }
}

//评论btn
- (IBAction)talk_btn:(UIButton *)sender
{
    _index = sender.tag;
    if (_didclickBtn)
    {
        _didclickBtn(_index);
    }
}

//赞btn
- (IBAction)praise_btn:(UIButton *)sender
{
    NSUserDefaults * user  = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [user objectForKey:@"user_id"];
    //借口数据：
    NSDictionary *fieldDic = @{@"userId":user_id, @"id":_weiBo_ID};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:fieldDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = @{@"param":@"goodDynamic",@"token":@"",@"jsonParam":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:YTX_URL parameters:JsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         if ([responseObject[@"code"] intValue] == 0)
         {
             //判断图片，并替换图片
             if (_praiseBtn.selected == YES)
             {
                 _praiseBtn.selected = NO;
                 [_praiseBtn setImage:[UIImage imageNamed:@"赞1"] forState:UIControlStateSelected];
             }
             else if (_praiseBtn.selected == NO)
             {
                 _praiseBtn.selected = YES;
                 [_praiseBtn setImage:[UIImage imageNamed:@"赞-空"] forState:UIControlStateNormal];
             }
             NSLog(@"请求结果:%@",responseObject);
         }
     }
     failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"错误提示：%@",error);
     }];
}

@end
