//
//  AW_MinetopCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_UserModal.h"

@interface AW_MinetopCell : UITableViewCell

-(void)configSeparatorWith:(AW_UserModal*)modal;
/**
 *  @author cao, 15-09-13 12:09:04
 *
 *  我的头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/**
 *  @author cao, 15-09-13 12:09:21
 *
 *  我的名字
 */
@property (weak, nonatomic) IBOutlet UIButton *mineName;
/**
 *  @author cao, 15-09-13 12:09:29
 *
 *  会员图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipimage;
/**
 *  @author cao, 15-09-13 12:09:40
 *
 *  我的描述
 */
@property (weak, nonatomic) IBOutlet UILabel *mineDescribe;
/**
 *  @author cao, 15-09-13 12:09:53
 *
 *  我的作品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *mineProduceNum;
/**
 *  @author cao, 15-09-13 12:09:08
 *
 *  我的动态数量
 */
@property (weak, nonatomic) IBOutlet UILabel *mineDynamicNum;
/**
 *  @author cao, 15-09-13 12:09:19
 *
 *  我的关注数量
 */
@property (weak, nonatomic) IBOutlet UILabel *myAttentionNum;
/**
 *  @author cao, 15-09-13 12:09:32
 *
 *  我的粉丝数量
 */
@property (weak, nonatomic) IBOutlet UILabel *mineFansName;

/**
 *  @author cao, 15-09-13 12:09:13
 *
 *  按钮索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-09-13 12:09:25
 *
 *  点击按钮后的回调
 */
@property(nonatomic,copy)void(^didClickKindBtn)(NSInteger index);
/**
 *  @author cao, 15-11-12 16:11:15
 *
 *  点击按钮的回调(没有作品时的回调)
 */
@property(nonatomic,copy)void(^didClicjedBtns)(NSInteger index);

@end
