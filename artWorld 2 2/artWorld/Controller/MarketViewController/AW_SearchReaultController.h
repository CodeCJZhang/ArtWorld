//
//  AW_SearchReaultController.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_SearchResultDataSource.h"//搜索结果控制器
/**
 *  @author cao, 15-10-26 16:10:34
 *
 *  艺术品搜索结果控制器
 */
@interface AW_SearchReaultController : UIViewController

/**
 *  @author cao, 15-10-28 17:10:54
 *
 *  搜索结果数据源
 */
@property(nonatomic,strong)AW_SearchResultDataSource * searchDataSource;

@end
