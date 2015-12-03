//
//  AW_PersonalInformationModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_DeliveryAdressModal.h"
#import "AW_HobbyModal.h"
/**
 *  @author cao, 15-10-16 16:10:17
 *
 *  获取个人资料接口
 */
@interface AW_PersonalInformationModal : Node

/**
 *  @author cao, 15-11-06 11:11:07
 *
 *  用来存放偏好数组
 */
@property(nonatomic,strong)NSArray * hobbyArray;
/**
 *  @author cao, 15-11-06 11:11:08
 *
 *  收货地址modal
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * adressModal;
/**
 *  @author cao, 15-10-16 16:10:01
 *
 *  用户头像url
 */
@property(nonatomic,copy)NSString * head_img;
/**
 *  @author cao, 15-10-16 16:10:03
 *
 *  用户昵称
 */
@property(nonatomic,copy)NSString * nickname;
/**
 *  @author cao, 15-10-16 16:10:06
 *
 *  生日（1984-05-22）
 */
@property(nonatomic,copy)NSString * birthday;
/**
 *  @author cao, 15-11-06 11:11:23
 *
 *  所在地省份
 */
@property(nonatomic,copy)NSString * province_name;
/**
 *  @author cao, 15-11-06 11:11:26
 *
 *  所在地城市
 */
@property(nonatomic,copy)NSString * city_name;
/**
 *  @author cao, 15-11-06 11:11:28
 *
 *  所在地省份id
 */
@property(nonatomic,copy)NSString * province_id;
/**
 *  @author cao, 15-11-06 11:11:31
 *
 *  所在地城市id
 */
@property(nonatomic,copy)NSString * city_id;
/**
 *  @author cao, 15-11-06 11:11:33
 *
 *   家乡省id
 */
@property(nonatomic,copy)NSString * hometown_province_id;
/**
 *  @author cao, 15-11-06 11:11:35
 *
 *  家乡市id
 */
@property(nonatomic,copy)NSString * hometown_city_id;
/**
 *  @author cao, 15-11-06 11:11:38
 *
 *  家乡省名称
 */
@property(nonatomic,copy)NSString * hometown_province_name;
/**
 *  @author cao, 15-11-06 11:11:40
 *
 *  家乡市名称
 */
@property(nonatomic,copy)NSString * hometown_city_name;

/**
 *  @author cao, 15-10-16 16:10:14
 *
 *  个人标签
 */
@property(nonatomic,copy)NSString * personal_label;
/**
 *  @author cao, 15-10-16 16:10:16
 *
 *  偏好
 */
@property(nonatomic,strong)AW_HobbyModal * hobbyModal;
/**
 *  @author cao, 15-10-16 16:10:19
 *
 *  用户个性签名
 */
@property(nonatomic,copy)NSString * signature;
/**
 *  @author cao, 15-10-16 16:10:21
 *
 *  个人简介
 */
@property(nonatomic,copy)NSString * synopsis;
/**
 *  @author cao, 15-10-16 16:10:23
 *
 *  收货地址
 */
@property(nonatomic,copy)NSString * delivery_address;
/**
 *  @author cao, 15-10-16 16:10:30
 *
 *  cell类型
 */
@property(nonatomic,copy)NSString * cellType;
/**
 *  @author cao, 15-11-06 11:11:49
 *
 *  手机号码
 */
@property(nonatomic,copy)NSString * phone;
/**
 *  @author cao, 15-11-07 15:11:29
 *
 *  偏好字符串
 */
@property(nonatomic,copy)NSString* hobbyString;
/**
 *  @author cao, 15-11-11 10:11:34
 *
 *  偏好id
 */
@property(nonatomic,copy)NSString * hobbyId;

@end
