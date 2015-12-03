//
//  AW_BigClassModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/26.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-26 16:10:04
 *
 *  大分类modal
 */
@interface AW_BigClassModal : Node

/**
 *  @author cao, 15-10-26 16:10:48
 *
 *  大分类id
 */
@property(nonatomic,copy)NSString * bid_id;
/**
 *  @author cao, 15-10-26 16:10:51
 *
 *  大分类名称
 */
@property(nonatomic,copy)NSString * big_name;
/**
 *  @author cao, 15-10-26 16:10:53
 *
 *  大分类图片
 */
@property(nonatomic,copy)NSString * bid_image;
/**
 *  @author cao, 15-10-26 20:10:21
 *
 *  临时的图片
 */
@property(nonatomic,copy)NSString * tmpImage;
@end
