//
//  AW_CheckPhonePersonCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_CheckPhonePersonCell : UITableViewCell
/**
 *  @author cao, 15-09-15 19:09:28
 *
 *  手机联系人名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  @author cao, 15-09-15 19:09:45
 *
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *smallNameLabel;
/**
 *  @author cao, 15-09-15 19:09:51
 *
 *  关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
/**
 *  @author cao, 15-11-13 16:11:57
 *
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

/**
 *  @author cao, 15-09-15 19:09:14
 *
 *  点击关注按钮后的回调
 */
@property(nonatomic,copy)void(^didClickAttentionBtn)(NSIndexPath *indexPath);
/**
 *  @author cao, 15-09-15 19:09:33
 *
 *  索引
 */
@property(nonatomic)NSIndexPath *indexPath;

@end
