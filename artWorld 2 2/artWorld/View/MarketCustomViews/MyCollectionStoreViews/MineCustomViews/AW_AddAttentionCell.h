//
//  AW_AddAttentionCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @author cao, 15-09-15 09:09:54
 *
 *  添加关注cell
 */
@interface AW_AddAttentionCell : UITableViewCell
/**
 *  @author cao, 15-09-15 10:09:36
 *
 *  点击cell的回调
 */
@property(nonatomic,copy)void(^didclickButton)(NSInteger index);
/**
 *  @author cao, 15-09-15 10:09:51
 *
 *  按钮的标签
 */
@property(nonatomic)NSInteger index;

@end
