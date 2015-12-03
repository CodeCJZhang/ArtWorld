//
//  AW_DeliveryAdressController.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_DeliveryAdressDataSource.h"
#import "AW_DeliveryAdressModal.h"

@protocol AW_DeliveryAdressDelegete <NSObject>

-(void)didClickedDeliveryCell:(AW_DeliveryAdressModal*)adressModal;

@end
/**
 *  @author cao, 15-09-01 16:09:41
 *
 *  收货地址控制器
 */
@interface AW_DeliveryAdressController : UIViewController
/**
 *  @author cao, 15-11-07 15:11:48
 *
 *  收货地址modal
 */
@property(nonatomic,strong)AW_DeliveryAdressModal * adressModal;
/**
 *  @author cao, 15-09-01 17:09:09
 *
 *  收货地址数据源
 */
@property(nonatomic,strong)AW_DeliveryAdressDataSource * deliveryDataSource;
/**
 *  @author cao, 15-10-16 18:10:52
 *
 *  委托对象
 */
@property(nonatomic,weak)id<AW_DeliveryAdressDelegete>delegate;

@end
