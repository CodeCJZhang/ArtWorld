//
//  AW_OrderStateCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_MyOrderModal.h"

@interface AW_OrderStateCell : UITableViewCell
/**
 *  @author cao, 15-10-12 17:10:16
 *
 *  付款按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
/**
 *  @author cao, 15-10-12 17:10:31
 *
 *  取消订单按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  @author cao, 15-10-12 17:10:44
 *
 *  联系卖家按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
/**
 *  @author cao, 15-10-12 17:10:09
 *
 *  确认收货按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmDeliveryBtn;
/**
 *  @author cao, 15-10-12 17:10:33
 *
 *  查看物流按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *lookDeliveryBtn;
/**
 *  @author cao, 15-10-12 17:10:44
 *
 *  评价按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *evaluteBtn;
/**
 *  @author cao, 15-10-12 17:10:57
 *
 *  删除订单按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteOrderBtn;
/**
 *  @author cao, 15-10-14 10:10:19
 *
 *  提醒发货按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *remindSnedBtn;

/**
 *  @author cao, 15-10-12 17:10:09
 *
 *  商品总价格
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceAndDeliveryPrice;
/**
 *  @author cao, 15-10-12 22:10:23
 *
 *  运费价格
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryPrice;

/**
 *  @author cao, 15-10-12 17:10:22
 *
 *  商品的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *articleNumber;
/**
 *  @author cao, 15-09-17 16:09:01
 *
 *  点击了提醒发货按钮后的回调
 */
@property(nonatomic,copy)void(^didClickRemindBtn)();
/**
 *  @author cao, 15-10-13 17:10:22
 *
 *  点击待评价cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedWaitEvaluteCellBtns)(NSInteger btnTag);
/**
 *  @author cao, 15-10-14 10:10:07
 *
 *  点击待付款cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedWaitPayCellBtns)(NSInteger btnTag);
/**
 *  @author cao, 15-10-14 10:10:07
 *
 *  点击待收货cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedWaitReceiveCellBtns)(NSInteger btnTag);
/**
 *  @author cao, 15-10-14 10:10:07
 *
 *  点击交易已成功cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedOrderSucessCellBtns)(NSInteger btnTag);
/**
 *  @author cao, 15-10-14 10:10:07
 *
 *  点击交易关闭cell上的按钮的回调
 */
@property(nonatomic,copy)void(^didClickedOrderCloseBtn)();
/**
 *  @author cao, 15-10-13 17:10:41
 *
 *  待评价cell上的按钮标签
 */
@property(nonatomic)NSInteger BtnTag;

@end
