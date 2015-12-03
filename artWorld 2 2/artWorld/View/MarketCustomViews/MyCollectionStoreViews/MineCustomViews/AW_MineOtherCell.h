//
//  AW_MineOtherCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MineOtherCell : UITableViewCell
/**
 *  @author cao, 15-09-13 14:09:13
 *
 *  上部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  @author cao, 15-09-13 14:09:26
 *
 *  中部视图
 */
@property (weak, nonatomic) IBOutlet UIView *middleView;
/**
 *  @author cao, 15-09-13 14:09:17
 *
 *  点击按钮后的回调
 */
@property(nonatomic,copy)void(^didClickKindBtn)(NSInteger index);
/**
 *  @author cao, 15-09-13 14:09:38
 *
 *  按钮的标签
 */
@property(nonatomic)NSInteger index;

@end
