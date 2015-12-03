//
//  AW_PersonSearchCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/30.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_PersonSearchCell : UITableViewCell

/**
 *  @author cao, 15-11-30 11:11:37
 *
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/**
 *  @author cao, 15-11-30 11:11:39
 *
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/**
 *  @author cao, 15-11-30 11:11:42
 *
 *  vip头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-11-30 11:11:45
 *
 *  关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
/**
 *  @author cao, 15-11-30 11:11:00
 *
 *  点击关注按钮的回调
 */
@property(nonatomic,copy)void(^didClickedBtn)(NSInteger index);
/**
 *  @author cao, 15-11-30 11:11:02
 *
 *  索引
 */
@property(nonatomic)NSInteger index;

@end
