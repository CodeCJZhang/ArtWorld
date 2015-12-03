//
//  AW_HotClassModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-23 09:10:02
 *
 *  热门分类Modal
 */
@interface AW_HotClassModal : Node

/**
 *  @author cao, 15-10-23 09:10:38
 *
 *  热门分类id
 */
@property(nonatomic,copy)NSString * class_id;
/**
 *  @author cao, 15-10-23 09:10:40
 *
 *  热门分类图标url
 */
@property(nonatomic,copy)NSString * class_image;
/**
 *  @author cao, 15-10-23 09:10:45
 *
 *  热门分类名称
 */
@property(nonatomic,copy)NSString * class_name;

@end
