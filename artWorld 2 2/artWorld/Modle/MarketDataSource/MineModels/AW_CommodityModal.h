//
//  AW_CommodityModal.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/14.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "Node.h"
/**
 *  @author cao, 15-10-14 09:10:45
 *
 *  商品modal
 */
@interface AW_CommodityModal : Node

/**
 *  @author cao, 15-11-24 21:11:26
 *
 *  艺术品邮费
 */
@property(nonatomic,copy)NSString * commidity_freight;
/**
 *  @author cao, 15-11-24 22:11:51
 *
 *  商铺下的总运费
 */
@property(nonatomic,copy)NSString * all_freight;
/**
 *  @author cao, 15-10-12 21:10:47
 *
 *  艺术品id
 */
@property(nonatomic,copy)NSString * commodity_Id;
/**
 *  @author cao, 15-11-04 10:11:36
 *
 *  记录id
 */
@property(nonatomic,copy)NSString * ID;
/**
 *  @author cao, 15-10-30 11:10:29
 *
 *  购物车id
 */
@property(nonatomic,copy)NSString * shopCart_id;
/**
 *  @author cao, 15-10-12 21:10:56
 *
 *  艺术品名称
 */
@property(nonatomic,copy)NSString * commodity_Name;
/**
 *  @author cao, 15-10-12 21:10:04
 *
 *  艺术品清晰图片url
 */
@property(nonatomic,copy)NSString * clearImageURL;
/**
 *  @author cao, 15-10-12 21:10:19
 *
 *  艺术品模糊图片url
 */
@property(nonatomic,copy)NSString * fuzzyImageURL;
/**
 *  @author cao, 15-10-12 21:10:37
 *
 *  艺术品价格
 */
@property(nonatomic,copy)NSString * commodityPrice;
/**
 *  @author cao, 15-10-12 21:10:47
 *
 *  艺术品数量
 */
@property(nonatomic,copy)NSString * commodityNumber;
/**
 *  @author cao, 15-10-12 21:10:00
 *
 *  商品属性
 */
@property(nonatomic,copy)NSString * commodityTyde;
/**
 *  @author cao, 15-10-14 16:10:37
 *
 *  艺术品最新价格
 */
@property(nonatomic,copy)NSString * commodity_newPrice;
/**
 *  @author cao, 15-10-14 16:10:41
 *
 *  艺术品的历史价格
 */
@property(nonatomic,copy)NSString * commodity_OldPrice;
/**
 *  @author cao, 15-10-14 16:10:43
 *
 *  用户选中的颜色
 */
@property(nonatomic,copy)NSString * commodity_color;
/**
 *  @author cao, 15-10-30 13:10:35
 *
 *  该艺术品的所有颜色
 */
@property(nonatomic,copy)NSString * all_colors;
/**
 *  @author cao, 15-10-14 16:10:45
 *
 *  艺术品失效原因
 */
@property(nonatomic,copy)NSString * invalidReason;
/**
 *  @author cao, 15-10-14 16:10:53
 *
 *  商品是否失效
 */
@property(nonatomic,copy)NSString* isInvalid;
/**
 *  @author cao, 15-10-14 16:10:07
 *
 *  所属的商铺名称
 */
@property(nonatomic,copy)NSString * belongStoreName;
/**
 *  @author cao, 15-11-02 10:11:49
 *
 *  所属的商铺id
 */
@property(nonatomic,copy)NSString * belongSrote_id;
/**
 *  @author cao, 15-10-15 11:10:15
 *
 *  艺术品图片的宽度
 */
@property(nonatomic)int commidity_width;
/**
 *  @author cao, 15-10-15 11:10:18
 *
 *  艺术品图片的高度
 */
@property(nonatomic)int commidity_height;
/**
 *  @author cao, 15-10-15 11:10:21
 *
 *  当前登录用户是否已经收藏该艺术品
 */
@property(nonatomic)BOOL isCollected;
/**
 *  @author cao, 15-10-15 16:10:57
 *
 *  该艺术品所属的分类
 */
@property(nonatomic,copy)NSString * classId;
/**
 *  @author cao, 15-11-05 11:11:57
 *
 *  订单id
 */
@property(nonatomic,copy)NSString * order_id;
/**
 *  @author cao, 15-11-11 16:11:09
 *
 *  对艺术品的评分【好评=1；中评=2；差评=3】
 */
@property(nonatomic,copy)NSString * comment_state;
/**
 *  @author cao, 15-11-11 16:11:13
 *
 *  对艺术品的评价内容
 */
@property(nonatomic,copy)NSString * comment_content;

@end
