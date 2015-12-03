//
//  AW_MyShopCartModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_StoreModal.h"
#import "AW_CommodityModal.h"
#import "AW_DeliveryAdressModal.h"
/**
 *  @author cao, 15-10-14 16:10:28
 *
 *  我的购物车modal
 */
@interface AW_MyShopCartModal : Node
/**
 *  @author cao, 15-10-14 17:10:05
 *
 *  收货地址modal
 */
@property(nonatomic,strong)AW_DeliveryAdressModal *adressModal;
/**
 *  @author cao, 15-10-14 16:10:04
 *
 *  是否是分割线
 */
@property(nonatomic)BOOL isSeparate;
/**
 *  @author cao, 15-10-14 16:10:57
 *
 *  总记录数
 */
@property(nonatomic,copy)NSString * totalNumber;
/**
 *  @author cao, 15-10-14 16:10:00
 *
 *  商城和圈子是否有新消息
 */
@property(nonatomic)BOOL hasUnread;
/**
 *  @author cao, 15-10-14 16:10:02
 *
 *  购物车里的失效商品的数量
 */
@property(nonatomic)int invalidNum;
/**
 *  @author cao, 15-10-14 16:10:07
 *
 *  商铺modal
 */
@property(nonatomic,strong)AW_StoreModal * storeModal;
/**
 *  @author cao, 15-10-14 16:10:09
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal * commodityModal;

/**
 *  @author cao, 15-10-14 16:10:23
 *
 *  商品子数组
 */
@property(nonatomic,strong)NSMutableArray * subArray;
/**
 *  @author cao, 15-10-14 16:10:37
 *
 *  编辑艺术品的数量
 */
@property(nonatomic,copy)NSString * editeArticleNum;
/**
 *  @author cao, 15-11-05 11:11:43
 *
 *  留言信息
 */
@property(nonatomic,copy)NSString * leaveMessage;
/**
 *  @author cao, 15-11-05 11:11:46
 *
 *  优惠券是否可用
 */
@property(nonatomic)BOOL coupsonState;
/**
 *  @author cao, 15-11-24 22:11:17
 *
 *  总运费
 */
@property(nonatomic,copy)NSString * total_freight;
@end
