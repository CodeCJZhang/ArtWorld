//
//  AW_QuestionListController.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/10.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_QuestionListDataSource.h"

/**
 *  @author cao, 15-11-10 14:11:36
 *
 *  问题列表接口
 */
@interface AW_QuestionListController : UIViewController

/**
 *  @author cao, 15-11-10 14:11:41
 *
 *  常见问题数据源
 */
@property(nonatomic,strong)AW_QuestionListDataSource * questionDataSource;
@end
