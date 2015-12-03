//
//  AW_PaySucessModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/19.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_CommodityModal.h"
/**
 *  @author cao, 15-10-19 18:10:40
 *
 *  支付成功modal
 */
@interface AW_PaySucessModal : Node
/**
 *  @author cao, 15-10-19 20:10:08
 *
 *  总记录数
 */
@property(nonatomic,copy)NSString * totalNumber;
/**
 *  @author cao, 15-10-19 20:10:12
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal * commodityModal;
/**
 *  @author cao, 15-10-19 20:10:41
 *
 *  艺术品cell的大小
 */
@property(nonatomic)CGSize  size;

@end
