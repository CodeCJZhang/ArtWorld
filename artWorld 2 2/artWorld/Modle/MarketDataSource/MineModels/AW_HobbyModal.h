//
//  AW_HobbyModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/6.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

@interface AW_HobbyModal : Node

/**
 *  @author cao, 15-11-06 11:11:52
 *
 *  id
 */
@property(nonatomic,copy)NSString * hobby_id;
/**
 *  @author cao, 15-11-06 11:11:55
 *
 *  名称
 */
@property(nonatomic,copy)NSString * hobbyName;
/**
 *  @author cao, 15-11-06 11:11:58
 *
 *  分类编号
 */
@property(nonatomic,copy)NSString * hobby_type;

@end
