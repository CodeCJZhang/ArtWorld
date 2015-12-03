//
//  AW_StoreModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
/**
 *  @author cao, 15-10-14 09:10:31
 *
 *  商铺modal
 */
@interface AW_StoreModal : Node
/**
 *  @author cao, 15-10-12 21:10:53
 *
 *  店铺id
 */
@property(nonatomic,copy)NSString * shop_Id;
/**
 *  @author cao, 15-11-09 14:11:31
 *
 *  店主id
 */
@property(nonatomic,copy)NSString * shoper_id;
/**
 *  @author cao, 15-11-02 09:11:05
 *
 *  优惠券号码
 */
@property(nonatomic,copy)NSString * coupons;
/**
 *  @author cao, 15-11-02 09:11:07
 *
 *  给卖家的留言
 */
@property(nonatomic,copy)NSString * leaveMessage;
/**
 *  @author cao, 15-10-12 21:10:17
 *
 *  店铺名称
 */
@property(nonatomic,copy)NSString * shop_Name;
/**
 *  @author cao, 15-10-14 09:10:30
 *
 *  店主环信id
 */
@property(nonatomic,copy)NSString*shoper_IM_Id;
/**
 *  @author cao, 15-11-24 21:11:21
 *
 *  该店铺下所有商品的运费
 */
@property(nonatomic,copy)NSString * totalFreight;
/**
 *  @author cao, 15-11-04 10:11:19
 *
 *  订单状态
 */
@property(nonatomic,copy)NSString * state;
/**
 *  @author cao, 15-10-15 14:10:37
 *
 *  店主头像url
 */
@property(nonatomic,copy)NSString * head_img;
/**
 *  @author cao, 15-10-15 14:10:40
 *
 *  店主的所在地
 */
@property(nonatomic,copy)NSString * shoper_adress;
/**
 *  @author cao, 15-11-09 14:11:56
 *
 *  店铺所在省份
 */
@property(nonatomic,copy)NSString * shop_province;
/**
 *  @author cao, 15-11-09 14:11:59
 *
 *  店铺所在城市
 */
@property(nonatomic,copy)NSString * shop_city;
/**
 *  @author cao, 15-10-15 14:10:42
 *
 *  店主的作品数量
 */
@property(nonatomic,copy)NSString * works_num;
/**
 *  @author cao, 15-10-15 14:10:45
 *
 *  店主的微博数量
 */
@property(nonatomic,copy)NSString * dynamic_num;
/**
 *  @author cao, 15-10-15 14:10:48
 *
 *  粉丝数量
 */
@property(nonatomic,copy)NSString * fan_num;
/**
 *  @author cao, 15-10-15 14:10:52
 *
 *  店主关注了多少人
 */
@property(nonatomic,copy)NSString * concern_num;
/**
 *  @author cao, 15-11-04 10:11:28
 *
 *  订单合计钱数
 */
@property(nonatomic,copy)NSString * totalPrice;
/**
 *  @author cao, 15-11-04 10:11:31
 *
 *  邮费
 */
@property(nonatomic,copy)NSString *freight;
/**
 *  @author cao, 15-11-11 16:11:58
 *
 *  描述相符评分
 */
@property(nonatomic,copy)NSString * content_grade;
/**
 *  @author cao, 15-11-11 16:11:00
 *
 *  物流服务评分
 */
@property(nonatomic,copy)NSString * flow_grade;
/**
 *  @author cao, 15-11-11 16:11:02
 *
 *  服务态度
 */
@property(nonatomic,copy)NSString * service_attitude;

@end
