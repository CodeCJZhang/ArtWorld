//
//  AW_QuestionListDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/10.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_QuestionModal.h"
/**
 *  @author cao, 15-11-10 14:11:09
 *
 *  问题列表数据源
 */
@interface AW_QuestionListDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-11-10 14:11:43
 *
 *  栏目id
 */
@property(nonatomic,copy)NSString * column_id;
/**
 *  @author cao, 15-11-10 15:11:14
 *
 *  栏目名称
 */
@property(nonatomic,copy)NSString * column_Title;
/**
 *  @author cao, 15-11-10 15:11:28
 *
 *  获取数据
 */
-(void)getData;
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
 *  @author cao, 15-11-10 15:11:24
 *
 *  点击cell的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(AW_QuestionModal * modal);
/**
 *  @author cao, 15-11-10 15:11:42
 *
 *  问题modal
 */
@property(nonatomic,strong)AW_QuestionModal * questionModal;

@end
