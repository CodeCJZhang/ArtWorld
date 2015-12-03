//
//  AW_PayDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/5.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_DeliveryAdressModal.h"

/**
 *  @author cao, 15-11-05 10:11:29
 *
 *  付款控制器
 */
@interface AW_PayDataSource : IMB_TableDataSource

/**
 *  @author cao, 15-11-05 10:11:37
 *
 *  用来接上个界面传过来的订单id
 */
@property(nonatomic,copy)NSString * order_id;
/**
 *  @author cao, 15-11-05 10:11:11
 *
 *  用来记录艺术品总价格
 */
@property(nonatomic,copy)NSString * totalPrice;
/**
 *  @author cao, 15-11-24 16:11:56
 *
 *  商品运费
 */
@property(nonatomic,copy)NSString * freight;
@property(nonatomic)float tmpFreight;
/**
 *  @author cao, 15-11-05 14:11:46
 *
 *  艺术品数组
 */
@property(nonatomic,strong)NSMutableArray * commidityArray;
/**
 *  @author cao, 15-11-05 14:11:48
 *
 *  记录收货地址modal
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * adressModal;
/**
 *  @author cao, 15-11-05 10:11:31
 *
 *  获取数据
 */
-(void)getData;
/**
 *  @author cao, 15-11-05 14:11:20
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(NSString * commidityId);
/**
 *  @author cao, 15-11-05 14:11:32
 *
 *  记录艺术品id
 */
@property(nonatomic,copy)NSString * commidity_id;
/**
 *  @author cao, 15-11-24 16:11:00
 *
 *  店铺信息数组
 */
@property(nonatomic,strong)NSMutableArray * storeModalArray;

@end
