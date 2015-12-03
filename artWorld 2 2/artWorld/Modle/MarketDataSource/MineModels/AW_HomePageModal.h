//
//  AW_HomePageModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/20.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-20 09:10:12
 *
 *  个人主页接口
 */
@interface AW_HomePageModal : Node

/**
 *  @author cao, 15-10-20 09:10:57
 *
 *  用户昵称
 */
@property(nonatomic,copy)NSString * nickName;
/**
 *  @author cao, 15-10-20 09:10:00
 *
 *  用户的店铺名称
 */
@property(nonatomic,copy)NSString * shopName;
/**
 *  @author cao, 15-10-20 09:10:03
 *
 *  用户环信id
 */
@property(nonatomic,copy)NSString * user_hxid;
/**
 *  @author cao, 15-10-20 09:10:05
 *
 *  用户头像url
 */
@property(nonatomic,copy)NSString * head_img;
/**
 *  @author cao, 15-10-20 09:10:08
 *
 *  用户是否是经过认证
 */
@property(nonatomic)BOOL  isVerified;
/**
 *  @author cao, 15-10-20 09:10:11
 *
 *  用户是否有店铺
 */
@property(nonatomic)BOOL hasShop;
/**
 *  @author cao, 15-10-20 09:10:13
 *
 *  被查看用户是否被当前登录用户关注
 */
@property(nonatomic)BOOL  isAttended;
/**
 *  @author cao, 15-10-20 09:10:16
 *
 *  被查看用户的店铺是否被当前登录用户收藏
 */
@property(nonatomic)BOOL isCollected;
/**
 *  @author cao, 15-10-20 09:10:19
 *
 *  用户描述
 */
@property(nonatomic,copy)NSString * synopsis;
/**
 *  @author cao, 15-10-20 09:10:21
 *
 *  用户作品数量
 */
@property(nonatomic,copy)NSString * works_num;
/**
 *  @author cao, 15-10-20 09:10:24
 *
 *  用户关注了多少人
 */
@property(nonatomic,copy)NSString * concern_num;
/**
 *  @author cao, 15-10-20 09:10:27
 *
 *  用户的粉丝数量
 */
@property(nonatomic,copy)NSString * fan_num;
/**
 *  @author cao, 15-10-20 09:10:30
 *
 *  用户发表的微博数量
 */
@property(nonatomic,copy)NSString * dynamic_num;
/**
 *  @author cao, 15-11-09 15:11:15
 *
 *  认证状态
 */
@property(nonatomic,copy)NSString * authentication_state;
/**
 *  @author cao, 15-11-09 15:11:24
 *
 *  开店状态
 */
@property(nonatomic,copy)NSString * shop_state;

@end
