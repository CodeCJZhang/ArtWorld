//
//  AW_OtherTopInfoCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_OtherTopInfoCell : UITableViewCell
/**
 *  @author cao, 15-11-23 15:11:37
 *
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *head_img;
/**
 *  @author cao, 15-11-23 15:11:40
 *
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickname;
/**
 *  @author cao, 15-11-23 16:11:02
 *
 *  顶部容器视图
 */
@property (weak, nonatomic) IBOutlet UIView *headContainerView;

@end
