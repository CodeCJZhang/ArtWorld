//
//  AW_CarouselModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-23 09:10:09
 *
 *  市集轮播图modal
 */
@interface AW_CarouselModal : Node

/**
 *  @author cao, 15-10-23 09:10:01
 *
 *  轮播艺术品id
 */
@property(nonatomic,copy)NSString * artwork_id;
/**
 *  @author cao, 15-10-23 09:10:05
 *
 *  艺术品清晰图片url
 */
@property(nonatomic,copy)NSString * artwork_clearImage;
/**
 *  @author cao, 15-10-23 09:10:12
 *
 *  艺术品模糊图片url
 */
@property(nonatomic,copy)NSString * artwork_fuzzyImage;

@end
