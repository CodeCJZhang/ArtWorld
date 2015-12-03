//
//  AW_MyFansDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
/**
 *  @author cao, 15-08-18 15:08:15
 *
 *  我的粉丝数据源
 */
@interface AW_MyFansDataSource : IMB_TableDataSource

/**
 *  @author cao, 15-11-09 21:11:24
 *
 *  用来记录被查看人的id
 */
@property(nonatomic,copy)NSString * person_id;
/**
 *  @author cao, 15-11-28 10:11:56
 *
 *  点击粉丝按钮（没有登录时点击确定按钮的回调）
 */
@property(nonatomic,copy)void(^didClickedFansConfirmBrn)();

@end
