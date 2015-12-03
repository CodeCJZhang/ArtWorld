//
//  AW_OtherInfoController.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_OtherInfoDataSource.h"

/**
 *  @author cao, 15-11-23 14:11:42
 *
 *  查看他人信息控制器
 */
@interface AW_OtherInfoController : UIViewController
/**
 *  @author cao, 15-11-23 14:11:06
 *
 *  他人信息数据源
 */
@property(nonatomic,strong)AW_OtherInfoDataSource * infoDataSource;

@end
