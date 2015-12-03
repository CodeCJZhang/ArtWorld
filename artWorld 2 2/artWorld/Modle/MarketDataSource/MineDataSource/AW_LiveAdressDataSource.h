//
//  AW_LiveAdressDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/27.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
/**
 *  @author cao, 15-09-27 10:09:28
 *
 *  所在地数据源
 */
@interface AW_LiveAdressDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-09-27 15:09:47
 *
 *  获取所有数据
 */
-(void)getData;
/**
 *  @author cao, 15-09-27 15:09:56
 *
 *  获取要展示在界面上的数据
 */
-(void)configDisplayData;
/**
 *  @author cao, 15-09-27 18:09:07
 *
 *  点击cell后的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(NSString * adressString);
/**
 *  @author cao, 15-09-27 18:09:23
 *
 *  所在地
 */
@property(nonatomic,copy)NSString * adressString;

@end
