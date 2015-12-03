//
//  AW_SimilaryCommodityModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/15.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_CommodityModal.h"
/**
 *  @author cao, 15-10-15 14:10:02
 *
 *  相似艺术品接口modal
 */
@interface AW_SimilaryCommodityModal : Node
/**
 *  @author cao, 15-10-15 14:10:34
 *
 *  总记录数
 */
@property(nonatomic,copy)NSString *totalNumber;
/**
 *  @author cao, 15-10-15 14:10:36
 *
 *  响应代码 【0成功 非0失败】
 */
@property(nonatomic,copy)NSString * code;
/**
 *  @author cao, 15-10-15 14:10:39
 *
 *  响应信息
 */
@property(nonatomic,copy)NSString * message;
/**
 *  @author cao, 15-10-19 16:10:52
 *
 *  活动的名称
 */
@property(nonatomic,copy)NSString * active_Name;
/**
 *  @author cao, 15-10-15 14:10:41
 *
 *  艺术品Modal
 */
@property(nonatomic,strong)AW_CommodityModal * commidityModal;
/**
 *  @author cao, 15-10-19 17:10:49
 *
 *  cell大小
 */
@property(nonatomic)CGSize size;

@end
