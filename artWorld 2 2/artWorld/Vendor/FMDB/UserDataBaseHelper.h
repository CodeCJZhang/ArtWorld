//
//  UserDataBaseHelper.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/19.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import <sqlite3.h>

@class AW_EMUserModal;
@interface UserDataBaseHelper : NSObject
/**
 *  @author cao, 15-11-19 14:11:50
 *
 *  数据库操作对象
 */
@property(nonatomic,strong)FMDatabase * fmdb;
/**
 *  @author cao, 15-11-19 14:11:01
 *
 *  查询所有的环信信息
 *
 *  @return 字典
 */
-(NSMutableDictionary*)queryAllUserInfo;
/**
 *  @author cao, 15-11-19 14:11:07
 *
 *  添加环信个人信息
 *
 *  @param userInfo 个人信息
 *
 *  @return bool
 */
-(BOOL)addCustomer:(AW_EMUserModal*)userInfo;
/**
 *  @author cao, 15-11-19 14:11:16
 *
 *  更新个人信息
 *
 *  @param userInfo 个人信息
 *
 *  @return bool
 */
-(BOOL)updateCustomer:(AW_EMUserModal*)userInfo;
/**
 *  @author cao, 15-11-19 14:11:18
 *
 *  删除环信个人信息
 *
 *  @param userInfo 个人信息
 *
 *  @return bool
 */
-(BOOL)deleteCustomer:(AW_EMUserModal*)userInfo;


@end
