//
//  AW_ProvinceModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/27.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-27 11:10:44
 *
 *  省份modal
 */
@interface AW_ProvinceModal : Node

/**
 *  @author cao, 15-10-27 11:10:49
 *
 *  省份id
 */
@property(nonatomic,copy)NSString *Province_id;
/**
 *  @author cao, 15-10-27 11:10:51
 *
 *  省份名称
 */
@property(nonatomic,copy)NSString *Province_name;
/**
 *  @author cao, 15-10-27 11:10:54
 *
 *  该省管辖下是否有城市
 */
@property(nonatomic)BOOL hasCity;

@end
