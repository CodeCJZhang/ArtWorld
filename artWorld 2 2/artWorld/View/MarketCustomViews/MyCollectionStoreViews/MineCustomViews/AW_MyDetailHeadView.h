//
//  AW_MyDetailHeadView.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AW_PersonalInformationModal.h"

@interface AW_MyDetailHeadView : UIView
/**
 *  @author cao, 15-08-17 10:08:01
 *
 *  我的头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
/**
 *  @author cao, 15-08-17 10:08:12
 *
 *  我的名字
 */

@property (weak, nonatomic) IBOutlet UILabel *myName;
/**
 *  @author cao, 15-08-17 10:08:20
 *
 *  vip头像
 */

@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-08-17 10:08:30
 *
 *  我的简介
 */
@property (weak, nonatomic) IBOutlet UILabel *myDescribe;
/**
 *  @author cao, 15-08-17 10:08:42
 *
 *  关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *attentionButtob;
/**
 *  @author cao, 15-08-17 10:08:58
 *
 *  收藏店铺按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
/**
 *  @author cao, 15-08-23 13:08:20
 *
 *  展示全部个人简介的视图
 */
@property (weak, nonatomic) IBOutlet UIButton *displayDescribeBtn;
/**
 *  @author cao, 15-11-17 17:11:32
 *
 *  展示详情覆盖button
 */
@property (weak, nonatomic) IBOutlet UIButton *displayDescribeCoverBtn;

/**
 *  @author cao, 15-08-23 13:08:58
 *
 *  顶部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-08-23 13:08:24
 *
 *  文本高度
 */
@property(nonatomic)float labelHeight;
/**
 *  @author cao, 15-08-23 14:08:50
 *
 *  上部视图高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstant;
/**
 *  @author cao, 15-08-23 16:08:05
 *
 *  整个视图的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewHeightContant;
/**
 *  @author cao, 15-09-18 16:09:29
 *
 *  加号图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *addAttentionImage;
/**
 *  @author cao, 15-09-18 16:09:49
 *
 *  关注覆盖按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *AttentionCover;
/**
 *  @author cao, 15-09-25 17:09:57
 *
 *  点击上部control的回调
 */
@property(nonatomic,copy)void(^didClickedTopControl)(NSInteger index);
/**
 *  @author cao, 15-09-25 17:09:11
 *
 *  临时的索引
 */
@property(nonatomic)NSInteger tmpIndex;
/**
 *  @author cao, 15-11-10 16:11:09
 *
 *  点击收藏或关注用户的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  @author cao, 15-11-10 16:11:13
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;

@end
