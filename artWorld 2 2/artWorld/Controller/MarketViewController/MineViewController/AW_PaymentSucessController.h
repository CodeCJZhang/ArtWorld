//
//  AW_PaymentSucessController.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_PaymentSucessDataSource.h"

/**
 *  @author cao, 15-09-12 17:09:54
 *
 *  支付成功控制器
 */
@interface AW_PaymentSucessController : UIViewController
/**
 *  @author cao, 15-09-12 17:09:14
 *
 *  支付成功数据源
 */
@property(nonatomic,strong)AW_PaymentSucessDataSource * paySucessDataSource;

@end
