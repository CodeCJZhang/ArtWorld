//
//  AW_SearchKeyDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/30.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"

/**
 *  @author cao, 15-11-30 10:11:30
 *
 *  搜索结果数据源
 */
@interface AW_SearchKeyDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-11-30 11:11:40
 *
 *  搜索关键字
 */
@property(nonatomic,copy)NSString * searchString;

/**
 *  @author cao, 15-10-27 15:10:55
 *
 *  记录总页数
 */
@property(nonatomic,copy)NSString * totolPage;
/**
 *  @author cao, 15-10-27 15:10:08
 *
 *  当前的页数
 */
@property(nonatomic,copy)NSString * currentPage;

/**
 *  @author cao, 15-11-30 14:11:13
 *
 *  获取搜索结果
 */
-(void)getData;

@end
