//
//  AW_SmallClassModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-26 16:10:00
 *
 *  小分类modal
 */
@interface AW_SmallClassModal : Node

/**
 *  @author cao, 15-10-26 16:10:49
 *
 *  小分类id
 */
@property(nonatomic,copy)NSString * small_id;
/**
 *  @author cao, 15-11-13 14:11:18
 *
 *  标签字符串
 */
@property(nonatomic,copy)NSString * labelString;
/**
 *  @author cao, 15-10-26 16:10:52
 *
 *  小分类名称
 */
@property(nonatomic,copy)NSString * small_name;

@end
