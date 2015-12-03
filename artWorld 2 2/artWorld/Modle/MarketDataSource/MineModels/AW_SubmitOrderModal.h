//
//  AW_SubmitOrderModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
/**
 *  @author cao, 15-10-15 14:10:05
 *
 *  提交订单接口modal
 */
/*
 备注：店铺id、优惠券号码和给卖家的留言内容组成一个json对象提交，可能会提交多个
 */
@interface AW_SubmitOrderModal : Node

/**
 *  @author cao, 15-10-15 14:10:35
 *
 *  当前登录用户id
 */
@property(nonatomic,copy)NSString * user_id;
/**
 *  @author cao, 15-10-15 14:10:39
 *
 *  收货地址id
 */
@property(nonatomic,copy)NSString * adress_id;
/**
 *  @author cao, 15-10-15 14:10:41
 *
 *  是否匿名购买【不匿名=0；匿名=1】
 */
@property(nonatomic,copy)NSString * anonymousBuy;
/**
 *  @author cao, 15-10-15 14:10:44
 *
 *  店铺id
 */
@property(nonatomic,copy)NSString * store_id;
/**
 *  @author cao, 15-10-15 14:10:47
 *
 *  优惠券号码
 */
@property(nonatomic,copy)NSString * coupons;
/**
 *  @author cao, 15-10-15 14:10:49
 *
 *  给卖家的留言内容
 */
@property(nonatomic,copy)NSString *leaveMessage;

@end
