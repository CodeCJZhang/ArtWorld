//
//  AW_MarketModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_CommodityModal.h"//艺术品modal
#import "AW_CarouselModal.h"//轮播图modal
#import "AW_HotClassModal.h"//热门分类modal

/**
 *  @author cao, 15-10-23 09:10:26
 *
 *  市集接口Modal
 */
@interface AW_MarketModal : Node

/**
 *  @author cao, 15-10-23 09:10:37
 *
 *  总记录数
 */
@property(nonatomic,copy)NSString * totolNumber;
/**
 *  @author cao, 15-10-23 09:10:42
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal * commidityModal;
/**
 *  @author cao, 15-10-23 09:10:45
 *
 *  轮播图modal
 */
@property(nonatomic,strong)AW_CarouselModal * carouselModal;
/**
 *  @author cao, 15-10-23 09:10:47
 *
 *  热门分类modal
 */
@property(nonatomic,strong)AW_HotClassModal * hotClassModal;
/**
 *  @author cao, 15-10-23 10:10:41
 *
 *  cell的大小
 */
@property(nonatomic)CGSize size;

@end
