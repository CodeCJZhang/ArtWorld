//
//  AW_CommonQuestionModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
/**
 *  @author cao, 15-10-16 15:10:18
 *
 *  常见问题接口Modal
 */
@interface AW_CommonQuestionModal : Node
/**
 *  @author cao, 15-10-16 15:10:35
 *
 *  总记录数
 */
@property(nonatomic,copy)NSString * totalNumber;
/**
 *  @author cao, 15-10-16 15:10:07
 *
 *  栏目id
 */
@property(nonatomic,copy)NSString * column_id;
/**
 *  @author cao, 15-10-16 15:10:09
 *
 *  栏目名称
 */
@property(nonatomic,copy)NSString * column_name;
/**
 *  @author cao, 15-10-16 15:10:12
 *
 *  问题id
 */
@property(nonatomic,copy)NSString * questions_id;
/**
 *  @author cao, 15-10-16 15:10:14
 *
 *  问题标题
 */
@property(nonatomic,copy)NSString * questions_title;
/**
 *  @author cao, 15-10-16 16:10:39
 *
 *  问题内容
 */
@property(nonatomic,copy)NSString * question_content;
/**
 *  @author cao, 15-10-16 15:10:47
 *
 *  栏目下的问题列表（每个栏目下最多三个问题)
 */
@property(nonatomic,strong)NSMutableArray * questionSubArray;

@end
