//
//  AW_DeliveryAdressAlertView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_DeliveryAdressModal.h"

@interface AW_DeliveryAdressAlertView : UIView
/**
 *  @author cao, 15-09-02 12:09:31
 *
 *  收货人姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *deliveryName;
/**
 *  @author cao, 15-09-02 12:09:44
 *
 *  收货人电话号码
 */
@property (weak, nonatomic) IBOutlet UITextField *deliveryPhoneNumber;
/**
 *  @author cao, 15-09-02 12:09:55
 *
 *  收货人地址
 */
@property (weak, nonatomic) IBOutlet UITextField *deliveryAdress;
/**
 *  @author cao, 15-09-02 12:09:04
 *
 *  确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/**
 *  @author cao, 15-09-07 16:09:27
 *
 *  收货地址(用来接修改以后或者新添加的收货地址)
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * adressModal;
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击确定按钮回调
 */
@property (nonatomic,copy)void (^didClickConfirmBtn)(AW_DeliveryAdressModal * modal);
@end
