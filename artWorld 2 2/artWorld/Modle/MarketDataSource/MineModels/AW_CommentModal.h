//
//  AW_CommentModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
/**
 *  @author cao, 15-10-14 15:10:15
 *
 *  评论modal
 */
@interface AW_CommentModal : Node
/**
 *  @author cao, 15-10-14 15:10:23
 *
 *  当前登录用户id
 */
@property(nonatomic,copy)NSString * userId;
/**
 *  @author cao, 15-10-14 15:10:26
 *
 *   店铺id
 */
@property(nonatomic,copy)NSString *storeId;
/**
 *  @author cao, 15-10-14 15:10:29
 *
 *  描述相符评分
 */
@property(nonatomic,copy)NSString* describeGrade;
/**
 *  @author cao, 15-10-14 15:10:31
 *
 *  物流服务评分
 */
@property(nonatomic,copy)NSString * deliveryGrade;
/**
 *  @author cao, 15-10-14 15:10:34
 *
 *  服务态度
 */
@property(nonatomic,copy)NSString * serviceManner;
/**
 *  @author cao, 15-10-14 15:10:37
 *
 *  艺术品id
 */
@property(nonatomic,copy)NSString * articleId;
/**
 *  @author cao, 15-10-14 15:10:39
 *
 *  对艺术品的评分【好评=1；中评=2；差评=3】
 */
@property(nonatomic,copy)NSString* articleGrade;
/**
 *  @author cao, 15-10-14 15:10:42
 *
 *  对艺术品的评价内容
 */
@property(nonatomic,copy)NSString * evaluteContent;

@end
