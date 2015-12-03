//
//  AW_CityModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/27.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-27 11:10:23
 *
 *  城市modal
 */
@interface AW_CityModal : Node

/**
 *  @author cao, 15-10-27 11:10:58
 *
 *  城市id
 */
@property(nonatomic,copy)NSString * city_id;
/**
 *  @author cao, 15-10-27 11:10:07
 *
 *  城市名称
 */
@property(nonatomic,copy)NSString * city_name;

@end
