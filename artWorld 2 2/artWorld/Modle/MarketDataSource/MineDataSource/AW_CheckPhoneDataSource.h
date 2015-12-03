//
//  AW_CheckPhoneDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
/**
 *  @author cao, 15-09-15 19:09:58
 *
 *  查看手机联系人数据源
 */
@interface AW_CheckPhoneDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-09-15 22:09:06
 *
 *  获取数据
 */
-(void)getData;
/**
 *  @author cao, 15-09-26 09:09:46
 *
 *  点击section索引的回调
 */
@property(nonatomic,copy)void(^didClickedSectionIndex)(NSString * sectionTitle);
/**
 *  @author cao, 15-09-26 09:09:03
 *
 *  sectionTitle
 */
@property(nonatomic,copy)NSString *sectionTitle;

@end
