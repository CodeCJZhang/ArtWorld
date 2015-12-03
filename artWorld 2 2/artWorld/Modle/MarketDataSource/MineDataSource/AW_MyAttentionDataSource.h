//
//  AW_MyAttentionDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/13.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"

/**
 *  @author cao, 15-08-18 09:08:28
 *
 *  我关注的人数据源
 */
@interface AW_MyAttentionDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-09-15 09:09:14
 *
 *  点击添加关注按钮的回调
 */
@property(nonatomic,copy)void(^didClickBtn)(NSInteger index);
/**
 *  @author cao, 15-11-09 17:11:15
 *
 *  被查看的人的用户id
 */
@property(nonatomic,copy)NSString * person_id;
/**
 *  @author cao, 15-11-28 10:11:42
 *
 *  点击确定登陆按钮的回调
 */
@property(nonatomic,copy)void(^didClickedConfirmBtn)();

@end
