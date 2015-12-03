//
//  AW_ArtCommentModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/29.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-29 18:10:51
 *
 *  评论modal
 */
@interface AW_ArtCommentModal : Node

/**
 *  @author cao, 15-10-29 18:10:26
 *
 *  评论id
 */
@property(nonatomic,copy)NSString * comment_id;
/**
 *  @author cao, 15-10-29 18:10:28
 *
 *  评论人名称
 */
@property(nonatomic,copy)NSString * nickname;
/**
 *  @author cao, 15-10-29 18:10:31
 *
 *  评论人头像url
 */
@property(nonatomic,copy)NSString * head_img;
/**
 *  @author cao, 15-10-29 18:10:34
 *
 *  评论人给的评分
 */
@property(nonatomic,copy)NSString * evaluation;
/**
 *  @author cao, 15-10-29 18:10:36
 *
 *  评论语
 */
@property(nonatomic,copy)NSString * content;
/**
 *  @author cao, 15-10-29 18:10:39
 *
 *  回复
 */
@property(nonatomic,copy)NSString * reply;
/**
 *  @author cao, 15-10-29 18:10:41
 *
 *  评论时间截
 */
@property(nonatomic,copy)NSString * comment_time;
/**
 *  @author cao, 15-10-29 22:10:48
 *
 *  分类
 */
@property(nonatomic,copy)NSString * class_id;
/**
 *  @author cao, 15-10-29 22:10:15
 *
 *  cell的类型
 */
@property(nonatomic,copy)NSString * cellType;

@end
