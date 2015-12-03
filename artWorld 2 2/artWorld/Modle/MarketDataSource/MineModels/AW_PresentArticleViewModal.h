//
//  AW_PresentArticleViewModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
#import "AW_MyShopCartModal.h"
/**
 *  @author cao, 15-09-19 10:09:28
 *
 *  弹出的展示商品详情modal
 */
@interface AW_PresentArticleViewModal : Node
/**
 *  @author cao, 15-09-20 11:09:03
 *
 *  是否有上分割线
 */
@property(nonatomic)BOOL hasTopSeparator;
/**
 *  @author cao, 15-09-19 14:09:01
 *
 *  单元格的类型
 */
@property(nonatomic,copy)NSString * type;
/**
 *  @author cao, 15-09-19 11:09:38
 *
 *  左侧标题
 */
@property(nonatomic,copy)NSString* leftLabelString;
/**
 *  @author cao, 15-09-19 10:09:02
 *
 *  产品详情(包含图片等信息)
 */
@property(nonatomic,strong)AW_CommodityModal * articleModal;
/**
 *  @author cao, 15-09-19 10:09:23
 *
 *  产品详情
 */
@property(nonatomic,copy)NSString *presentArticleDetail;
/**
 *  @author cao, 15-09-19 10:09:40
 *
 *  艺术品大小
 */
@property(nonatomic,copy)NSString * articleSize;
/**
 *  @author cao, 15-09-19 10:09:51
 *
 *  艺术品颜色
 */
@property(nonatomic,strong)NSString * articleColor;
/**
 *  @author cao, 15-09-19 10:09:59
 *
 *  艺术品工艺
 */
@property(nonatomic,copy)NSString* articleCraft;
/**
 *  @author cao, 15-09-19 10:09:12
 *
 *  创作理念
 */
@property(nonatomic,copy)NSString * createIdea;
/**
 *  @author cao, 15-09-19 10:09:21
 *
 *  生产地
 */
@property(nonatomic,copy)NSString * produceArea;
/**
 *  @author cao, 15-09-19 10:09:30
 *
 *  发货地
 */
@property(nonatomic,copy)NSString * deliveryArea;
@end
