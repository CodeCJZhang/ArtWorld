//
//  AW_ArtDetailModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/24.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_DetailHeadModal.h"
#import "AW_DetailPriceModal.h"
#import "AW_DetailInfoModal.h"
#import "AW_DetailAuthorModal.h"
#import "AW_DetailSimilaryModal.h"

/**
 *  @author cao, 15-10-24 11:10:05
 *
 *  艺术品详情modal
 */
@interface AW_ArtDetailModal : Node

/**
 *  @author cao, 15-10-29 11:10:45
 *
 *  商品的状态(是否可用)
 */
@property(nonatomic,copy)NSString * commidity_state;
/**
 *  @author cao, 15-10-24 11:10:26
 *
 *  头部信息
 */
@property(nonatomic,strong)AW_DetailHeadModal * headModal;
/**
 *  @author cao, 15-10-24 11:10:28
 *
 *  价格信息
 */
@property(nonatomic,strong)AW_DetailPriceModal * priceModal;
/**
 *  @author cao, 15-10-24 11:10:31
 *
 *  艺术品详情信息
 */
@property(nonatomic,strong)AW_DetailInfoModal * infoModal;
/**
 *  @author cao, 15-10-24 11:10:34
 *
 *  作者信息
 */
@property(nonatomic,strong)AW_DetailAuthorModal * authorModal;
/**
 *  @author cao, 15-10-24 11:10:36
 *
 *  相似艺术品信息
 */
@property(nonatomic,strong)AW_DetailSimilaryModal * similaryModal;
/**
 *  @author cao, 15-10-24 11:10:39
 *
 *  cell的类型
 */
@property(nonatomic,copy)NSString * cellType;
/**
 *  @author cao, 15-10-24 13:10:07
 *
 *  子数组
 */
@property(nonatomic,strong)NSArray * subArray;

@end
