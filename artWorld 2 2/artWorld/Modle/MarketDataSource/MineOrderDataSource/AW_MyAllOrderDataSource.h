//
//  AW_MyAllOrderDataSource.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "IMB_TableDataSource.h"
#import "AW_MyOrderModal.h"

/**
 *  @author cao, 15-08-22 12:08:15
 *
 *  全部订单数据源
 */
@interface AW_MyAllOrderDataSource : IMB_TableDataSource

/**
 *  @author cao, 15-09-16 16:09:11
 *
 *  点击待评价cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickEvaluteCellButtons)(AW_MyOrderModal * modal ,NSInteger index);
/**
 *  @author cao, 15-09-17 16:09:27
 *
 *  点击待付款cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedPayMentButtons)(AW_MyOrderModal*modal,NSInteger index);
/**
 *  @author cao, 15-09-17 16:09:27
 *
 *  点击待收货cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedReceiveButtons)(AW_MyOrderModal*modal,NSInteger index);
/**
 *  @author cao, 15-09-17 16:09:54
 *
 *  点击提醒发货按钮的回调
 */
@property(nonatomic,copy)void(^didClickedRemindBtn)(AW_MyOrderModal * modal);
/**
 *  @author cao, 15-09-17 16:09:54
 *
 *  点击交易成功cell上按钮的回调
 */
@property(nonatomic,copy)void(^didClickedOrderSucessCellBtn)(AW_MyOrderModal* modal ,NSInteger index);
/**
 *  @author cao, 15-09-17 16:09:54
 *
 *  点击交易关闭cell上按钮的回调
 */
@property(nonatomic,copy)void(^didClickedOrderCloseCellBtn)(AW_MyOrderModal* modal);
/**
 *  @author cao, 15-09-18 11:09:47
 *
 *  将在全部订单列表中删除的订单记录下来
 */
@property(nonatomic,strong)NSMutableArray * deleteDataArray;
/**
 *  @author cao, 15-10-13 16:10:12
 *
 *  订单id
 */
@property(nonatomic,copy)NSString * orderId;
/**
 *  @author cao, 15-10-13 16:10:17
 *
 *  商铺id
 */
@property(nonatomic,copy)NSString * shopId;
/**
 *  @author cao, 15-10-13 21:10:59
 *
 *  我的订单模型
 */
@property(nonatomic,strong)AW_MyOrderModal * orderModal;
/**
 *  @author cao, 15-10-27 15:10:55
 *
 *  记录总页数
 */
@property(nonatomic,copy)NSString * totolPage;
/**
 *  @author cao, 15-10-27 15:10:08
 *
 *  当前的页数
 */
@property(nonatomic,copy)NSString * currentPage;
/**
 *  @author cao, 15-11-05 09:11:38
 *
 *  点击艺术品cell的回调
 */
@property(nonatomic,copy)void(^didClickedCell)(AW_CommodityModal * modal);
/**
 *  @author cao, 15-11-25 11:11:51
 *
 *  艺术品modal
 */
@property(nonatomic,strong)AW_CommodityModal * modal;
@end
