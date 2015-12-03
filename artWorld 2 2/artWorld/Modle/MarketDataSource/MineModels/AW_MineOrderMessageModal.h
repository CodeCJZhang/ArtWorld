//
//  AW_MineOrderMessageModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

@interface AW_MineOrderMessageModal : Node
/**
 *  @author cao, 15-09-13 15:09:21
 *
 *  待付款数量
 */
@property(nonatomic)NSInteger waitPayNum;
/**
 *  @author cao, 15-09-13 15:09:39
 *
 *  待发货数量
 */
@property(nonatomic)NSInteger waitDeliveryNum;
/**
 *  @author cao, 15-09-13 15:09:50
 *
 *  代收货数量
 */
@property(nonatomic)NSInteger waitReceiveNum;
/**
 *  @author cao, 15-09-13 15:09:00
 *
 *  待评价数量
 */
@property(nonatomic)NSInteger waitEvaluteNum;

@end
