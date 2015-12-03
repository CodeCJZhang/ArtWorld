//
//  AW_CommentEvaluteDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_MyOrderModal.h"
/**
 *  @author cao, 15-09-16 16:09:39
 *
 *  发表评论数据源
 */
@interface AW_CommentEvaluteDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-09-16 19:09:57
 *
 *  获取数据
 */
-(void)getData;
/**
 *  @author cao, 15-10-14 15:10:56
 *
 *  用来接上个界面传过来的modal
 */
@property(nonatomic,strong)AW_MyOrderModal * orderModal;

@end
