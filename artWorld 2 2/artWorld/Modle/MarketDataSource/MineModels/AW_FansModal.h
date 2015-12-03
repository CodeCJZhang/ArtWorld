//
//  AW_FansModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_UserModal.h"
/**
 *  @author cao, 15-10-16 23:10:32
 *
 *  被查看用户粉丝列表接口Modal || 被查看用户关注的人的列表接口Modal
 */
@interface AW_FansModal : Node

/**
 *  @author cao, 15-10-16 23:10:32
 *
 *  总记录数
 */
@property(nonatomic,copy)NSString * totalNumber;
/**
 *  @author cao, 15-10-16 23:10:34
 *
 *  粉丝modal
 */
@property(nonatomic,strong)AW_UserModal * userModal;
/**
 *  @author cao, 15-10-16 23:10:37
 *
 *  当前登录用户是否关注了该粉丝 || 当前登录用户是否关注了被关注用户
 */
@property(nonatomic)BOOL isAttended;

@end
