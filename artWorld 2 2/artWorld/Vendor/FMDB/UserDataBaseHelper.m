//
//  UserDataBaseHelper.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/19.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "UserDataBaseHelper.h"
#import "AW_EMUserModal.h"
#import "NSFileManager+Utils.h"

static NSString * SQL_FOR_QUERY_ALL_USERINFO =@"select *from t_userIM order by user_id ";

static NSString * SQL_FOR_ADD_USERINFO = @"insert into t_userIM(user_id,nickName,headImage,IM_phone) values (?,?,?,?)";

static NSString * SQL_FOR_UPDATE_USERINFO = @"update t_userIM set user_id = ?,nickName = ?,headImage =?,IM_phone = ? where user_id = ?";

static NSString * SQL_FOR_DELETE_USERINFO = @"delete from t_userIM where user_id = ?";

@interface UserDataBaseHelper()

@end

@implementation UserDataBaseHelper

-(FMDatabase*)fmdb{
    if (!_fmdb) {
        NSString * documentPath = [NSFileManager documentsDirectory];
        NSString * parh = [documentPath stringByAppendingPathComponent:@"Data.db"];
        NSLog(@"%@",parh);
        _fmdb = [FMDatabase databaseWithPath:parh];
    }
    return _fmdb;
}

-(NSMutableDictionary*)queryAllUserInfo{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    @try {
        if ([self.fmdb open]) {
            FMResultSet * queryResult = [self.fmdb executeQuery:SQL_FOR_QUERY_ALL_USERINFO];
            while ([queryResult next]) {
                //NSString* user_id = [queryResult stringForColumnIndex:0];
                //NSString * nick_Name = [queryResult stringForColumnIndex:1];
                NSString * head_image =[queryResult stringForColumnIndex:2];
                NSString * Im_phone = [queryResult stringForColumnIndex:3];
                if (![[dict allKeys] containsObject:Im_phone]) {
                    [dict setValue:head_image forKey:Im_phone];
                }
                
            }
        }
    }
    @finally {
        [self.fmdb close];
    }
    return dict;
}

-(BOOL)addCustomer:(AW_EMUserModal *)userInfo{
    BOOL flag;
    @try {
        if ([self.fmdb open]) {
            if ([self.fmdb executeUpdate:SQL_FOR_ADD_USERINFO,userInfo.user_id,userInfo.nickName,userInfo.headImage,userInfo.IM_phone]) {
                NSLog(@"添加成功。。。");
                flag = YES;
            }else{
            NSLog(@"添加失败:%@",[self.fmdb lastErrorMessage]);
                flag = NO;
            }
        }
    }
    @finally {
        [self.fmdb close];
    }
    return flag;
}

-(BOOL)updateCustomer:(AW_EMUserModal *)userInfo{
    BOOL flag;
    @try {
        if ([self.fmdb open]) {
            if ([self.fmdb executeUpdate:SQL_FOR_UPDATE_USERINFO,userInfo.user_id,userInfo.nickName,userInfo.headImage,userInfo.IM_phone]) {
                NSLog(@"修改成功。。。");
                flag = YES;
            }else{
                NSLog(@"修改失败:%@",[self.fmdb lastErrorMessage]);
                flag = NO;
            }
        }
    }
    @finally {
        [self.fmdb close];
    }
    return flag;
}

-(BOOL)deleteCustomer:(AW_EMUserModal *)userInfo{
    BOOL flag;
    @try {
        if ([self.fmdb open]) {
            if ([self.fmdb executeUpdate:SQL_FOR_DELETE_USERINFO,userInfo.user_id]) {
                NSLog(@"删除成功。。。");
                flag = YES;
            }else{
                NSLog(@"删除失败:%@",[self.fmdb lastErrorMessage]);
                flag = NO;
            }
        }
    }
    @finally {
        [self.fmdb close];
    }
    return flag;
}

@end
