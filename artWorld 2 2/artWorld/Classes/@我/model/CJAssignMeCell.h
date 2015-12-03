//
//  CJAssignMeCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJAssignMeCell : UITableViewCell

/**####################⬇️ 原文模式 ⬇️######################*/
//头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *name;

//认证
@property (weak, nonatomic) IBOutlet UIImageView *vip;

//时间
@property (weak, nonatomic) IBOutlet UILabel *time;

//微博简要
@property (weak, nonatomic) IBOutlet UILabel *content;

//图片集
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imageArray;

//底视图到微博简要
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToWeibo;

//底视图到第一行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToFirst;

//底视图到第二行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToSecond;

//底视图到第三行
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToThird;

/**####################⬇️ 转发模式 ⬇️######################*/

//头像
@property (weak, nonatomic) IBOutlet UIImageView *s_icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *s_name;

//认证
@property (weak, nonatomic) IBOutlet UIImageView *s_vip;

//时间
@property (weak, nonatomic) IBOutlet UILabel *s_time;

//微博简要
@property (weak, nonatomic) IBOutlet UILabel *s_content;

//原文简要
@property (weak, nonatomic) IBOutlet UILabel *ori_content;

//原文底视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end
