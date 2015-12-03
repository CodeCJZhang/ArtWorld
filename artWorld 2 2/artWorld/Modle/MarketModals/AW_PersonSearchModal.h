//
//  AW_PersonSearchModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/30.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

@interface AW_PersonSearchModal : Node

/**
 *  @author cao, 15-11-30 11:11:13
 *
 *  用户id
 */
@property(nonatomic,copy)NSString * person_id;
/**
 *  @author cao, 15-11-30 11:11:16
 *
 *  用户头像url
 */
@property(nonatomic,copy)NSString * head_image;
/**
 *  @author cao, 15-11-30 11:11:18
 *
 *  用户昵称
 */
@property(nonatomic,copy)NSString * nick_name;
/**
 *  @author cao, 15-11-30 11:11:21
 *
 *  认证状态【没有提出认证=0；认证中=1；认证失败=2，3认证成功】
 */
@property(nonatomic,copy)NSString * authentication_state;
/**
 *  @author cao, 15-11-30 11:11:24
 *
 *  当前登录用户是否关注了该用户
 */
@property(nonatomic)BOOL isAttended;

@end
