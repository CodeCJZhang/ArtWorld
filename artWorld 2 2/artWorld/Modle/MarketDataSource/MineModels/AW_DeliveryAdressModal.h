//
//  AW_DeliveryAdressModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_DeliveryAdressModal : NSObject
/**
 *  @author cao, 15-09-01 17:09:48
 *
 *  收货人姓名
 */
@property(nonatomic,copy)NSString * deliveryName;
/**
 *  @author cao, 15-09-01 17:09:08
 *
 *  收货人地址
 */
@property(nonatomic,copy)NSString * deliveryAdress;
/**
 *  @author cao, 15-09-01 17:09:26
 *
 *  收货人的电话号码
 */
@property(nonatomic,copy)NSString * deliveryPhoneNumber;
/**
 *  @author cao, 15-09-01 17:09:13
 *
 *  是否将其设为默认收货地址
 */
@property(nonatomic)BOOL isDefaultAdress;
/**
 *  @author cao, 15-10-15 11:10:11
 *
 *  收货地址id
 */
@property(nonatomic,copy)NSString *adress_Id;
/**
 *  @author cao, 15-11-05 15:11:31
 *
 *  是否是默认收货地址
 */
@property(nonatomic,copy)NSString * is_default;

@end
