//
//  AW_QuestionModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/10.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-11-10 10:11:56
 *
 *  常见问题modal
 */
@interface AW_QuestionModal : Node

/**
 *  @author cao, 15-11-10 10:11:28
 *
 *  问题id
 */
@property(nonatomic,copy)NSString * question_id;
/**
 *  @author cao, 15-11-10 10:11:31
 *
 *  问题标题
 */
@property(nonatomic,copy)NSString * question_title;
/**
 *  @author cao, 15-11-10 10:11:35
 *
 *  问题类型
 */
@property(nonatomic,copy)NSString * question_type;
/**
 *  @author cao, 15-11-10 10:11:38
 *
 *  问题内容
 */
@property(nonatomic,copy)NSString * question_content;
/**
 *  @author cao, 15-11-10 10:11:21
 *
 *  该栏目下的子问题数组
 */
@property(nonatomic,strong)NSMutableArray * subArray;

@end
