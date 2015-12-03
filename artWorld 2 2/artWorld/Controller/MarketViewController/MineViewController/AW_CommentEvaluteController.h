//
//  AW_CommentEvaluteController.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/16.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_CommentEvaluteDataSource.h"

/**
 *  @author cao, 15-09-16 16:09:05
 *
 *  发表评论控制器
 */
@interface AW_CommentEvaluteController : UIViewController

/**
 *  @author cao, 15-09-16 16:09:51
 *
 *  发表评论数据源
 */
@property(nonatomic,strong)AW_CommentEvaluteDataSource * commentDataSource;

@end
