//
//  AW_UserModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
/**
 *  @author cao, 15-10-16 20:10:42
 *
 *  UserModal
 */
@interface AW_UserModal : Node
/**
 *  @author cao, 15-10-22 11:10:30
 *
 *  cell的类型
 */
@property(nonatomic,strong)NSString * cellType;
/**
 *  @author cao, 15-10-16 23:10:17
 *
 *  用户环信id
 */
@property(nonatomic,copy)NSString * user_hxid;
/**
 *  @author cao, 15-10-16 23:10:20
 *
 *  用户id
 */
@property(nonatomic,copy)NSString * user_id;
/**
 *  @author cao, 15-10-16 20:10:11
 *
 *  被查看用户名称
 */
@property(nonatomic,copy)NSString * nickname;
/**
 *  @author cao, 15-10-16 20:10:14
 *
 *  被查看用户头像url
 */
@property(nonatomic,copy)NSString * head_img;
/**
 *  @author cao, 15-10-16 20:10:16
 *
 *  被查看用户是否是经过认证
 */
@property(nonatomic)BOOL isVerified;
/**
 *  @author cao, 15-10-16 20:10:19
 *
 *  个性签名
 */
@property(nonatomic,copy)NSString * signature;
/**
 *  @author cao, 15-10-19 21:10:37
 *
 *  用户是否有店铺
 */
@property(nonatomic)BOOL hasShop;
/**
 *  @author cao, 15-10-19 21:10:40
 *
 *  用户发表的微博数量
 */
@property(nonatomic,copy)NSString * dynamic_num;
/**
 *  @author cao, 15-10-19 21:10:43
 *
 *  用户关注了多少人
 */
@property(nonatomic,copy)NSString * concern_num;
/**
 *  @author cao, 15-10-19 21:10:46
 *
 *  用户的粉丝数量
 */
@property(nonatomic,copy)NSString * fan_num;
/**
 *  @author cao, 15-10-19 21:10:49
 *
 *  用户的作品数量
 */
@property(nonatomic,copy)NSString * works_num;
/**
 *  @author cao, 15-10-19 21:10:53
 *
 *  待付款未读数量
 */
@property(nonatomic,copy)NSString * waitPayUnreadNum;
/**
 *  @author cao, 15-10-19 21:10:56
 *
 *  待发货未读数量
 */
@property(nonatomic,copy)NSString * waitSendOutUnreadNum;
/**
 *  @author cao, 15-10-19 21:10:59
 *
 *  待收货未读数量
 */
@property(nonatomic,copy)NSString * waitReceiveUnreadNum;
/**
 *  @author cao, 15-10-19 21:10:02
 *
 *  待评价未读数量
 */
@property(nonatomic,copy)NSString * waitCommentUnreadNum;
/**
 *  @author cao, 15-10-19 21:10:05
 *
 *  认证状态【没有提出认证=0；认证中=1；认证失败=2】
 */
@property(nonatomic,copy)NSString *authentication_state;
/**
 *  @author cao, 15-10-19 21:10:07
 *
 *  申请开店状态【没有提出申请=0；申请中=1；申请失败=2】
 */
@property(nonatomic,copy)NSString * shop_state;

@end
