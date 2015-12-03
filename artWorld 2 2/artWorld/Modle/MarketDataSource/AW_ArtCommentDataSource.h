//
//  AW_ArtCommentDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"

/**
 *  @author cao, 15-10-29 17:10:21
 *
 *  艺术品评价数据源
 */
@interface AW_ArtCommentDataSource : IMB_TableDataSource

/**
 *  @author cao, 15-10-29 22:10:03
 *
 *  用来接传过来的艺术品id
 */
@property(nonatomic,copy)NSString * Art_id;
/**
 *  @author cao, 15-10-29 18:10:59
 *
 *  当前页数
 */
@property(nonatomic,copy)NSString * currentPage;
@end
