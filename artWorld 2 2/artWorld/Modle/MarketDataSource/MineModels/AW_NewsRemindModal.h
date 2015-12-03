//
//  AW_NewsRemindModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/28.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

@interface AW_NewsRemindModal : Node
/**
 *  @author cao, 15-08-28 19:08:32
 *
 *  消息提醒
 */
@property(nonatomic,strong)NSString * newsRemindString;
/**
 *  @author cao, 15-08-28 19:08:43
 *
 *  判断是否是分割线
 */
@property(nonatomic)BOOL isSeparate;
@end
