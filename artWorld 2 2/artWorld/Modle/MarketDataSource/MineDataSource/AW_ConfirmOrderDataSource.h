//
//  AW_ConfirmOrderDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_DeliveryAdressModal.h"

/**
 *  @author cao, 15-09-12 10:09:14
 *
 *  确认订单数据源
 */
@interface AW_ConfirmOrderDataSource : IMB_TableDataSource
/**
 *  @author cao, 15-09-12 11:09:19
 *
 *  获取数据
 */
-(void)getData;
/**
 *  @author cao, 15-09-13 08:09:33
 *
 *  用来接上个界面传过来的购买商品的modal
 */
@property(nonatomic,strong)NSMutableArray * PurchaseArticleModal;
/**
 *  @author cao, 15-11-24 14:11:05
 *
 *  用来接上个界面传过来的商铺modal
 */
@property(nonatomic,strong)NSMutableArray * storeArray;
/**
 *  @author cao, 15-09-20 16:09:50
 *
 *  选中cell某一行的回调
 */
@property(nonatomic,copy)void(^didSelectCell)(NSInteger index);
/**
 *  @author cao, 15-09-20 16:09:03
 *
 *  cell行的索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-09-20 16:09:00
 *
 *  收货地址modal(用于接下个界面传过来的数据)
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * adressModal;
/**
 *  @author cao, 15-11-24 15:11:03
 *
 *  默认收货地址
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * defaultAdressModal;
/**
 *  @author cao, 15-11-01 23:11:32
 *
 *  商铺数组（商铺下面包含艺术品数组,用于请求参数）
 */
@property(nonatomic,strong)NSMutableArray * storeModalArray;

/**
 *  @author cao, 15-11-02 10:11:13
 *
 *  优惠券字典
 */
@property(nonatomic,strong)NSMutableDictionary * couponsDict;
/**
 *  @author cao, 15-11-02 10:11:05
 *
 *  留言字典
 */
@property(nonatomic,strong)NSMutableDictionary * messageDict;
/**
 *  @author cao, 15-11-02 11:11:59
 *
 *  输入优惠券的回调
 */
@property(nonatomic,copy)void(^didClicked)(NSString * tipMessage);
/**
 *  @author cao, 15-11-02 11:11:01
 *
 *  提示信息
 */
@property(nonatomic,copy)NSString * tipMessage;
/**
 *  @author cao, 15-11-24 11:11:44
 *
 *  店铺modal数组
 */
@property(nonatomic,strong)NSMutableArray * shopModalArray;
/**
 *  @author cao, 15-11-24 17:11:46
 *
 *  记录运费
 */
@property(nonatomic)float total_freight;
/**
 *  @author cao, 15-12-01 17:12:49
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didClickedArtCell)(NSString * str);
/**
 *  @author cao, 15-12-01 17:12:20
 *
 *  艺术品id
 */
@property(nonatomic,copy)NSString * str;
@end
