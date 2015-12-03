//
//  CJForwardedMessageCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJForwardedMessageCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *name;

//认证
@property (weak, nonatomic) IBOutlet UIImageView *vip;

//时间
@property (weak, nonatomic) IBOutlet UILabel *time;

//转发文字
@property (weak, nonatomic) IBOutlet UILabel *content;

/**################### 原文 #####################*/

//原文
@property (weak, nonatomic) IBOutlet UILabel *ori_content;

//原文图片集
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imageArray;

//底部到正文
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToWeibo;

//底部到第一行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToFirst;

//底部到第二行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToSecond;

//底部到第三行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToThird;

@end
