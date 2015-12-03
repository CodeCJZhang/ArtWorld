//
//  AW_CheckPhoneManModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

@interface AW_CheckPhoneManModal : Node
/**
 *  @author cao, 15-11-13 16:11:46
 *
 *  用户id
 */
@property(nonatomic,copy)NSString * person_id;
/**
 *  @author cao, 15-11-13 16:11:41
 *
 *  手机联系人姓名
 */
@property(nonatomic,copy)NSString * person_name;
/**
 *  @author cao, 15-11-13 17:11:29
 *
 *  手机联系人拼音
 */
@property(nonatomic,copy)NSString * person_name_pinyin;
/**
 *  @author cao, 15-11-13 16:11:48
 *
 *  用户手机号
 */
@property(nonatomic,copy)NSString * phone;
/**
 *  @author cao, 15-11-13 16:11:51
 *
 *  用户的呢称
 */
@property(nonatomic,copy)NSString * nickname;
/**
 *  @author cao, 15-11-13 16:11:53
 *
 *   用户头像地址
 */
@property(nonatomic,copy)NSString * head_img;
/**
 *  @author cao, 15-11-13 16:11:56
 *
 *  当前登录用户是否关注了该用户
 */
@property(nonatomic)BOOL isAttended;

@end
