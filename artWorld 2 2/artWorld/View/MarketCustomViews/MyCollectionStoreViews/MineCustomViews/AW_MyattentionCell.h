//
//  AW_MyattentionCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MyattentionCell : UITableViewCell

/**
 *  @author cao, 15-08-15 13:08:29
 *
 *  我关注的人的头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;

/**
 *  @author cao, 15-08-15 13:08:53
 *
 *  我关注的人的姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  @author cao, 15-08-15 13:08:24
 *
 *  描述
 */

@property (weak, nonatomic) IBOutlet UILabel *describLabel;
/**
 *  @author cao, 15-08-15 13:08:54
 *
 *  vip图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-09-18 13:09:40
 *
 *  右侧关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
/**
 *  @author cao, 15-09-18 13:09:21
 *
 *  点击关注按钮后的回调
 */
@property(nonatomic,copy)void(^didClickAttentionBtn)(NSInteger index);
/**
 *  @author cao, 15-09-18 13:09:40
 *
 *  索引
 */
@property(nonatomic)NSInteger index;
@end
