//
//  CJPraiseCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJPraiseCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *name;

//认证
@property (weak, nonatomic) IBOutlet UIImageView *vip;

//时间
@property (weak, nonatomic) IBOutlet UILabel *time;

//微博图片
@property (weak, nonatomic) IBOutlet UIImageView *image;

//at了谁
@property (weak, nonatomic) IBOutlet UILabel *atLable;

//正文内容
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
