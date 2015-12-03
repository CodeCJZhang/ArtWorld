//
//  AW_SimilaryProduceController.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/9.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_SimilaryProduceDataSource.h"

/**
 *  @author cao, 15-10-09 18:10:50
 *
 *  相似产品控制器
 */
@interface AW_SimilaryProduceController : UIViewController
/**
 *  @author cao, 15-10-09 18:10:43
 *
 *  相似产品数据源
 */
@property(nonatomic,strong)AW_SimilaryProduceDataSource * similaryDataSource;
@end
