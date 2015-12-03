//
//  SearchDataBaseHelper.m
//  artWorld
//
//  Created by 曹学亮 on 15/11/28.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "SearchDataBaseHelper.h"
#import "NSFileManager+Utils.h"

static NSString * SQL_FOR_QUERY_ALL_KEYWORD =@"select *from t_keyWord order by id desc ";

static NSString * SQL_FOR_ADD_KEYWORD = @"insert into t_keyWord(keyWord) values (?)";

@implementation SearchDataBaseHelper

-(FMDatabase*)fmdb{
    if (!_fmdb) {
        NSString * documentPath = [NSFileManager documentsDirectory];
        NSString * parh = [documentPath stringByAppendingPathComponent:@"Data.db"];
        NSLog(@"%@",parh);
        _fmdb = [FMDatabase databaseWithPath:parh];
    }
    return _fmdb;
}

#pragma mark - FMDB menthod

-(NSMutableArray*)queryAllKeyWord{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    @try {
        if ([self.fmdb open]) {
            FMResultSet * result = [self.fmdb executeQuery:SQL_FOR_QUERY_ALL_KEYWORD];
            while ([result next]) {
                //NSInteger key_id = [result intForColumnIndex:0];
                NSString * key_word = [result stringForColumnIndex:1];
                [array addObject:key_word];
            }
        }
    }
    @finally {
        [self.fmdb close];
    }
    return array;
}


-(BOOL)addKeyWord:(NSString *)keyWord{
    BOOL flag;
    @try {
        if ([self.fmdb open]) {
            if ([self.fmdb executeUpdate:SQL_FOR_ADD_KEYWORD,keyWord]) {
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

@end
