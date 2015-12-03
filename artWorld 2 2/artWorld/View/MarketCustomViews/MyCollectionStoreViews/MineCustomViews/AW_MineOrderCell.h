//
//  AW_MineOrderCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MineOrderCell : UITableViewCell
/**
 *  @author cao, 15-09-13 13:09:44
 *
 *  待付款提示视图
 */
@property (weak, nonatomic) IBOutlet UIView *waitPayView;
/**
 *  @author cao, 15-09-13 13:09:12
 *
 *  代付款信息个数
 */
@property (weak, nonatomic) IBOutlet UILabel *waitPayLabel;
/**
 *  @author cao, 15-09-13 13:09:28
 *
 *  待发货提示视图
 */
@property (weak, nonatomic) IBOutlet UIView *waitDeliveryView;
/**
 *  @author cao, 15-09-13 13:09:55
 *
 *  待发货信息个数
 */
@property (weak, nonatomic) IBOutlet UILabel *waitDeliveryLabel;
/**
 *  @author cao, 15-09-13 13:09:10
 *
 *  待收货提示视图
 */
@property (weak, nonatomic) IBOutlet UIView *waitReceiveView;
/**
 *  @author cao, 15-09-13 13:09:23
 *
 *  代收货信息个数
 */
@property (weak, nonatomic) IBOutlet UILabel *waitReceiveLabel;
/**
 *  @author cao, 15-09-13 13:09:37
 *
 *  待评价提示视图
 */
@property (weak, nonatomic) IBOutlet UIView *waitEvaluteView;
/**
 *  @author cao, 15-09-13 13:09:52
 *
 *  待评价信息个数
 */
@property (weak, nonatomic) IBOutlet UILabel *waitEvaluteLabel;
/**
 *  @author cao, 15-09-13 13:09:02
 *
 *  按钮标签
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-09-13 13:09:15
 *
 *  点击按钮后的回调
 */
@property(nonatomic,copy)void (^didClickKindBtn)(NSInteger index);

@end
