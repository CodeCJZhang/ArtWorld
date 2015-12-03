//
//  AW_PayController.h
//  artWorld
//
//  Created by 曹学亮 on 15/11/5.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_PayDataSource.h"

/**
 *  @author cao, 15-11-05 10:11:18
 *
 *  点击我的订单付款按钮进入的控制器
 */
@interface AW_PayController : UIViewController

/**
 *  @author cao, 15-11-05 10:11:54
 *
 *  付款确认收货数据源
 */
@property(nonatomic,strong)AW_PayDataSource * payDataDouse;

@end
