//
//  AW_MyOrderModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/22.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_Constants.h"
#import "AW_CommodityModal.h"//艺术品modal
#import "AW_StoreModal.h"//店铺modal

@interface AW_MyOrderModal : Node
/**
 *  @author cao, 15-08-22 14:08:42
 *
 *  我的订单状态
 */
@property(nonatomic)ENUM_MINE_ORDER_STATE MyOrderState;
/**
 *  @author cao, 15-10-13 10:10:29
 *
 *  商品总数
 */
@property(nonatomic,copy)NSString * totalNumber;
/**
 *  @author cao, 15-10-12 21:10:44
 *
 *  订单id
 */
@property(nonatomic,copy)NSString * orderId;
/**
 *  @author cao, 15-10-12 21:10:04
 *
 *  订单合计钱数
 */
@property(nonatomic,copy)NSString * totalPrice;
/**
 *  @author cao, 15-10-12 21:10:21
 *
 *  订单运费
 */
@property(nonatomic,copy)NSString * deliveryPrice;
/**
 *  @author cao, 15-10-12 21:10:30
 *
 *  在这家店铺买的艺术品列表
 */
@property(nonatomic,strong)NSArray * subArray;
/**
 *  @author cao, 15-10-14 09:10:54
 *
 *  商铺modal
 */
@property(nonatomic,strong)AW_StoreModal * storeModal;
/**
 *  @author cao, 15-10-14 11:10:50
 *
 *  分割线modal
 */
@property(nonatomic,strong)AW_MyOrderModal * separateModal;
/**
 *  @author cao, 15-10-14 11:10:08
 *
 *  顶单商铺modal
 */
@property(nonatomic,strong)AW_MyOrderModal * OrderStoreModal;
/**
 *  @author cao, 15-10-14 09:10:11
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal * CommodityModal;
/**
 *  @author cao, 15-11-04 11:11:41
 *
 *  订单状态
 */
@property(nonatomic,copy)NSString * orderState;

@end
