//
//  AW_StoreCommentCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_StoreCommentCell : UITableViewCell
/**
 *  @author cao, 15-09-17 11:09:12
 *
 *  点击描述类按钮的回调
 */
@property(nonatomic,copy)void (^didClickDescribeBtn)(NSInteger index);
/**
 *  @author cao, 15-09-17 11:09:44
 *
 *  点击物流类按钮的回调
 */
@property(nonatomic,copy)void (^didClickDeliveryBtn)(NSInteger index);
/**
 *  @author cao, 15-09-17 11:09:59
 *
 *  点击服务类按钮的回调
 */
@property(nonatomic,copy)void (^didClickSericeBtn)(NSInteger index);
/**
 *  @author cao, 15-09-17 11:09:15
 *
 *  描述类按钮标签
 */
@property(nonatomic)NSInteger describeBtnTag;
/**
 *  @author cao, 15-09-17 11:09:28
 *
 *  物流类按钮标签
 */
@property(nonatomic)NSInteger deliveryBtnTag;
/**
 *  @author cao, 15-09-17 11:09:41
 *
 *  服务类按钮标签
 */
@property(nonatomic)NSInteger seriviceBtnTag;
/**
 *  @author cao, 15-09-17 11:09:18
 *
 *  描述按钮数组
 */
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *describeButtons;
/**
 *  @author cao, 15-09-17 11:09:28
 *
 *  物流按钮数组
 */
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deliveryButtons;
/**
 *  @author cao, 15-09-17 11:09:42
 *
 *  服务按钮数组
 */
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *seviercesButtons;

@end
