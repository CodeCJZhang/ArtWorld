//
//  AW_PaymentSucessHeadView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @author cao, 15-09-12 16:09:50
 *
 *  支付成功collectionView头视图
 */
@interface AW_PaymentSucessHeadView : UIView

/**
 *  @author cao, 15-09-12 16:09:10
 *
 *  收货人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryName;
/**
 *  @author cao, 15-09-12 16:09:21
 *
 *  收货人电话号码
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryPhone;
/**
 *  @author cao, 15-09-12 16:09:37
 *
 *  收货人地址
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryAdress;
/**
 *  @author cao, 15-09-12 16:09:50
 *
 *  邮费
 */
@property (weak, nonatomic) IBOutlet UILabel *PostagePrice;
/**
 *  @author cao, 15-09-12 16:09:01
 *
 *  全部费用
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/**
 *  @author cao, 15-09-12 16:09:11
 *
 *  联系卖家按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *connactBtn;
/**
 *  @author cao, 15-09-21 15:09:09
 *
 *  点击联系卖家按钮的回调
 */
@property(nonatomic,copy)void(^didClickedConectBtn)(NSString * string);
/**
 *  @author cao, 15-09-21 15:09:36
 *
 *  商铺名称
 */
@property(nonatomic,copy)NSString * storeString;

@end
