//
//  CJCommentMessageCell.h
//  artWorld
//
//  Created by 张晓旭 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJCommentMessageCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *icon;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *name;

//认证
@property (weak, nonatomic) IBOutlet UIImageView *vip;

//时间
@property (weak, nonatomic) IBOutlet UILabel *time;

//正文
@property (weak, nonatomic) IBOutlet UILabel *content;

//原微博回复文本
@property (weak, nonatomic) IBOutlet UILabel *respond_content;

//原微博图片
@property (weak, nonatomic) IBOutlet UIImageView *ori_image;

//原微博at博主
@property (weak, nonatomic) IBOutlet UILabel *atLable;

//原博文
@property (weak, nonatomic) IBOutlet UILabel *ori_content;

//图片到回复文字
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToReply;

//图片到顶部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToTop;


@property (nonatomic,strong) void (^toReply)();


@end
