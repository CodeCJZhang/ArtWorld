//
//  AW_ActiveController.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/18.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ActiveDataSource.h"
/**
 *  @author cao, 15-09-18 15:09:26
 *
 *  活动控制器
 */
@interface AW_ActiveController : UIViewController
/**
 *  @author cao, 15-09-18 16:09:50
 *
 *  活动数据源
 */
@property(nonatomic,strong)AW_ActiveDataSource * activeDataSource;

@end
