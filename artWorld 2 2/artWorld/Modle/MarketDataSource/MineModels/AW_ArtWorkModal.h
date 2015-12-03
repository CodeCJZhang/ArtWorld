//
//  AW_ArtWorkModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/17.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_CommodityModal.h"
/**
 *  @author cao, 15-10-17 11:10:12
 *
 *  我的作品modal
 */
@interface AW_ArtWorkModal : Node

/**
 *  @author cao, 15-10-17 11:10:34
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal * commidityModal;
/*
 如果第一页返回活动id、活动头图、被查看用户的作品数量，否则不返回
 */
/**
 *  @author cao, 15-10-17 14:10:23
 *
 *  总记录数
 */
@property(nonatomic,copy)NSString *totalNumber;
/**
 *  @author cao, 15-10-17 14:10:26
 *
 *  活动id
 */
@property(nonatomic,copy)NSString * activity_id;
/**
 *  @author cao, 15-10-17 14:10:28
 *
 *  活动头图清晰url
 */
@property(nonatomic,copy)NSString * active_clear_img;
/**
 *  @author cao, 15-10-17 14:10:31
 *
 *  活动头图模糊url
 */
@property(nonatomic,copy)NSString * active_fuzzy_img;
/**
 *  @author cao, 15-10-17 14:10:34
 *
 *  被查看用户的作品数量
 */
@property(nonatomic,copy)NSString * works_num;
/**
 *  @author cao, 15-10-17 14:10:36
 *
 *  分类id
 */
@property(nonatomic,copy)NSString * class_id;
/**
 *  @author cao, 15-10-17 14:10:39
 *
 *  分类名称
 */
@property(nonatomic,copy)NSString * class_name;
/**
 *  @author cao, 15-10-17 14:10:42
 *
 *  该分类下的作品数
 */
@property(nonatomic,copy)NSString * class_num;
/**
 *  @author cao, 15-10-17 14:10:37
 *
 *  图片的大小(对图片进行预处理)
 */
@property(nonatomic)CGSize size;
/**
 *  @author cao, 15-10-17 14:10:28
 *
 *  测试图片
 */
@property(nonatomic,strong)UIImage * image;

@end

