//
//  AW_SearchCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_SearchCell : UITableViewCell
/**
 *  @author cao, 15-09-15 12:09:04
 *
 *  用户名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  @author cao, 15-09-15 12:09:13
 *
 *  vip图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
/**
 *  @author cao, 15-09-15 12:09:22
 *
 *  关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
/**
 *  @author cao, 15-09-15 12:09:50
 *
 *  点击关注按钮后的回调
 */
@property(nonatomic,copy)void(^didClickedAttentionBtn)(NSInteger  index);
/**
 *  @author cao, 15-09-15 12:09:19
 *
 *  索引
 */
@property(nonatomic)NSInteger  index;
@end
