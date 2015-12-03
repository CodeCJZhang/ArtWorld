//
//  AW_SearchModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

@interface AW_SearchModal : Node
/**
 *  @author cao, 15-09-15 14:09:18
 *
 *  名字
 */
@property(nonatomic,copy)NSString * nameString;
/**
 *  @author cao, 15-09-15 14:09:18
 *
 *  名字拼音
 */
@property(nonatomic,copy)NSString * nameStringPinYin;
/**
 *  @author cao, 15-09-15 14:09:32
 *
 *  是否是vip
 */
@property(nonatomic)BOOL isVip;
/**
 *  @author cao, 15-09-15 14:09:46
 *
 *  是否被关注
 */
@property(nonatomic)BOOL isAttention;
@end
