//
//  AW_ArtCommetController.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ArtCommentDataSource.h"//艺术品评价数据源

/**
 *  @author cao, 15-10-29 17:10:25
 *
 *  艺术品评价控制器
 */
@interface AW_ArtCommetController : UIViewController

/**
 *  @author cao, 15-10-29 17:10:06
 *
 *  评论数据源
 */
@property(nonatomic,strong)AW_ArtCommentDataSource * commentDataSource;

@end
