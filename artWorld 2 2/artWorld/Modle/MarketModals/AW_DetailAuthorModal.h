//
//  AW_DetailAuthorModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/24.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-24 11:10:37
 *
 *  艺术品作者和店铺modal
 */
@interface AW_DetailAuthorModal : Node

/**
 *  @author cao, 15-10-24 11:10:55
 *
 *  作者id
 */
@property(nonatomic,copy)NSString * user_id;
/**
 *  @author cao, 15-10-24 11:10:58
 *
 *  作者的店铺名称
 */
@property(nonatomic,copy)NSString * shopName;
/**
 *  @author cao, 15-10-24 11:10:00
 *
 *  作者头像url
 */
@property(nonatomic,copy)NSString * head_img;
/**
 *  @author cao, 15-10-24 11:10:04
 *
 *  作者所在地-省
 */
@property(nonatomic,copy)NSString * province_name;
/**
 *  @author cao, 15-10-24 11:10:06
 *
 *  作者所在地-市
 */
@property(nonatomic,copy)NSString * city_name;
/**
 *  @author cao, 15-10-24 11:10:10
 *
 *  作者的作品数量
 */
@property(nonatomic,copy)NSString * works_num;
/**
 *  @author cao, 15-10-24 11:10:12
 *
 *  作者的粉丝数量
 */
@property(nonatomic,copy)NSString * fan_num;
/**
 *  @author cao, 15-10-24 11:10:15
 *
 *  作者发表的动态数量
 */
@property(nonatomic,copy)NSString * dynamic_num;

@end
