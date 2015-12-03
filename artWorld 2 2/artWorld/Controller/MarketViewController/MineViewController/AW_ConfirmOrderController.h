//
//  AW_ConfirmOrderController.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_ConfirmOrderDataSource.h"
/**
 *  @author cao, 15-09-12 11:09:28
 *
 *  确认订单控制器
 */
@interface AW_ConfirmOrderController : UIViewController
/**
 *  @author cao, 15-09-12 11:09:09
 *
 *  商品总价格
 */
@property(nonatomic)float articleTotalPrice;
/**
 *  @author cao, 15-09-11 18:09:50
 *
 *  确认订单数据源
 */
@property(nonatomic,strong)AW_ConfirmOrderDataSource * confirmOrderDataSource;
/**
 *  @author cao, 15-11-02 09:11:39
 *
 *  收货地址id
 */
@property(nonatomic,copy)NSString * adress_id;


@end
