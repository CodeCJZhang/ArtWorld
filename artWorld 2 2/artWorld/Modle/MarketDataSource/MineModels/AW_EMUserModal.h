//
//  AW_EMUserModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/19.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-11-19 11:11:03
 *
 *  环信个人信息modal
 */
@interface AW_EMUserModal : Node

/**
 *  @author cao, 15-11-19 11:11:38
 *
 *  用户id
 */
@property(nonatomic,copy)NSString * user_id;
/**
 *  @author cao, 15-11-19 11:11:41
 *
 *  昵称
 */
@property(nonatomic,copy)NSString * nickName;
/**
 *  @author cao, 15-11-19 11:11:43
 *
 *  头像
 */
@property(nonatomic,copy)NSString * headImage;
/**
 *  @author cao, 15-11-19 11:11:45
 *
 *  手机号
 */
@property(nonatomic,copy)NSString * IM_phone;

@end
