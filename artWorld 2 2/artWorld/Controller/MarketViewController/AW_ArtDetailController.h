//
//  AW_ArtDetailController.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ArtDetailDataSource.h"//艺术品详情数据源
/**
 *  @author cao, 15-10-23 14:10:58
 *
 *  艺术品详情控制器
 */
@interface AW_ArtDetailController : UIViewController
//标记
@property(nonatomic,copy)NSString * tmpString;
/**
 *  @author cao, 15-10-23 14:10:51
 *
 *  艺术品详情数据源
 */
@property(nonatomic,strong)AW_ArtDetailDataSource * detailDataSource;
/**
 *  @author cao, 15-11-27 23:11:23
 *
 *  判读是否从广告图点进来的
 */
@property(nonatomic,copy)NSString* advertisementNumber;

@end
