//
//  AW_DetailPriceModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/24.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"

/**
 *  @author cao, 15-10-24 11:10:11
 *
 *  艺术品详情价格和运费modal
 */
@interface AW_DetailPriceModal : Node

/**
 *  @author cao, 15-10-24 11:10:19
 *
 *  艺术品价格
 */
@property(nonatomic,copy)NSString * price;
/**
 *  @author cao, 15-10-24 11:10:24
 *
 *  艺术品运费
 */
@property(nonatomic,copy)NSString * freight;

@end
