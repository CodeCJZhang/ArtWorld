//
//  ArtSearchDataBaseHelper.h
//  artWorld
//
//  Created by 曹学亮 on 15/12/3.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <sqlite3.h>

@interface ArtSearchDataBaseHelper : NSObject

/**
 *  @author cao, 15-11-19 14:11:50
 *
 *  数据库操作对象
 */
@property(nonatomic,strong)FMDatabase * fmdb;
/**
 *  @author cao, 15-11-28 15:11:52
 *
 *  查询所有的搜索关键字
 *
 *  @return 关键字数组
 */
-(NSMutableArray*)queryAllKeyWord;
/**
 *  @author cao, 15-11-28 15:11:19
 *
 *  向数据库中添加搜索关键字
 *
 *  @param keyWord 搜索关键字
 *
 *  @return BOOL
 */
-(BOOL)addKeyWord:(NSString*)keyWord;

@end
