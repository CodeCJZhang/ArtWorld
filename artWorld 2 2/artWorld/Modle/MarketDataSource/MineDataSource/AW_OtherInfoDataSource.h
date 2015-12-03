//
//  AW_OtherInfoDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
/**
 *  @author cao, 15-11-23 14:11:54
 *
 *  查看他人信息数据源
 */
@interface AW_OtherInfoDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-11-23 14:11:00
 *
 *  被查看用户的user_id
 */
@property(nonatomic,copy)NSString * user_id;
/**
 *  @author cao, 15-11-23 14:11:31
 *
 *  获取数据
 */
-(void)getData;

@end
