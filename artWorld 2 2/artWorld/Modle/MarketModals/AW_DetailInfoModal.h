//
//  AW_DetailInfoModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/24.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-24 11:10:11
 *
 *  艺术品详情信息modal
 */
@interface AW_DetailInfoModal : Node

/**
 *  @author cao, 15-10-24 11:10:56
 *
 *  艺术品描述，HTML文本数据
 */
@property(nonatomic,copy)NSString * details;
/**
 *  @author cao, 15-11-15 21:11:50
 *
 *  年代
 */
@property(nonatomic,copy)NSString * create_time;
/**
 *  @author cao, 15-11-15 21:11:58
 *
 *  作者名字
 */
@property(nonatomic,copy)NSString * auther_name;
/**
 *  @author cao, 15-10-24 11:10:00
 *
 *  尺寸
 */
@property(nonatomic,copy)NSString * size;
/**
 *  @author cao, 15-10-24 11:10:04
 *
 *  颜色标签，多个标签用英文逗号分隔(字段名不是color，color有其他用途)
 */
@property(nonatomic,copy)NSString * color;
/**
 *  @author cao, 15-10-24 11:10:08
 *
 *  工艺
 */
@property(nonatomic,copy)NSString * technology;
/**
 *  @author cao, 15-10-24 11:10:11
 *
 *  产地
 */
@property(nonatomic,copy)NSString * origin_place;
/**
 *  @author cao, 15-10-24 11:10:13
 *
 *  产品发货地
 */
@property(nonatomic,copy)NSString * delivery_place;
/**
 *  @author cao, 15-10-24 11:10:15
 *
 *  库存数量
 */
@property(nonatomic)NSInteger stockNum;
/**
 *  @author cao, 15-10-24 11:10:18
 *
 *  年代
 */
@property(nonatomic,copy)NSString * age;
/**
 *  @author cao, 15-10-24 11:10:20
 *
 *  创作理念
 */
@property(nonatomic,copy)NSString * create_idea;

@end
