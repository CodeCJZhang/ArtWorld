//
//  AW_Constants.h
//  artWorld
//
//  Created by 张亚哲 on 15/7/9.
//  Copyright (c) 2015年 张亚哲. All rights reserved.

#import "IMB_Constants.h"
#import "IMB_Macro.h"
/**
 *  @author zhe, 15-07-09 09:07:57
 *
 *  艺天下app 宏定义
 */
#ifndef artWorld_AW_Constants_h
#define artWorld_AW_Constants_h

#define PLACE_HOLDERIMAGE [UIImage imageNamed:@"empty_photo"]
#define TMP_IMAGE  [UIImage imageNamed:@"empty_photo"]
#define PLACEHOLDERIMAGE [UIImage imageNamed:@"empty_photo.png"]

#define GREENCORLOR HexRGB(0x88c244)

/**
*  艺圈列表枚举
*/
typedef NS_ENUM(NSInteger, ENUM_CIRCLE_LIST_TYPE){
    /**
     *  @author zhe, 15-07-15 10:07:30
     *
     *  圈子广场
     */
    ENUM_CIRCLE_LIST_CIRCLE = 0,
    /**
     *  @author zhe, 15-07-15 10:07:54
     *
     *  好友动态
     */
    ENUM_CIRCLE_LIST_FRIEND = 1,
    /**
     *  @author zhe, 15-07-15 10:07:16
     *
     *  我的动态
     */
    ENUM_CIRCLE_LIST_MY = 2,

};


/**
 *  @author zhe, 15-07-16 17:07:04
 *
 *  我的列表类型
 */
typedef NS_ENUM(NSInteger, ENUM_MINE_LIST_TYPE){
    /**
     *  @author zhe, 15-07-16 17:07:50
     *
     *  我的列表头
     */
    ENUM_MINE_LIST_HEADER = 0,
    /**
     *  @author zhe, 15-07-16 17:07:19
     *
     *  我的列表分割线
     */
    ENUM_MINE_LIST_SEPARATE = 1,
    /**
     *  @author zhe, 15-07-16 17:07:10
     *
     *  普通列表
     */
    ENUM_MINE_LIST_COMMON = 2,
    /**
     *  @author zhe, 15-07-16 17:07:33
     *
     *  订单列表
     */
    ENUM_MINE_LIST_ORDER = 3,
    /**
     *  @author zhe, 15-07-16 17:07:52
     *
     *  作品
     */
    ENUM_MINE_LIST_WORK = 4,
};


/**
 *  @author cao, 15-08-22 14:08:18
 *
 *  我的订单状态
 */
typedef NS_ENUM(NSInteger, ENUM_MINE_ORDER_STATE){
    /**
     *  @author cao, 15-08-22 14:08:18
     *
     *  待付款
     */
    ENUM_MINE_ORDER_WAITPAY = 0,
    /**
     *  @author cao, 15-08-22 14:08:18
     *
     *  待发货
     */
    ENUM_MINE_ORDER_WAITSEND = 1,
    /**
     *  @author cao, 15-08-22 14:08:18
     *
     *  待收货
     */
    ENUM_MINE_ORDER_WAITRECEIVE = 2,
    /**
     *  @author cao, 15-08-22 14:08:18
     *
     *  待评价
     */
    ENUM_MINE_ORDER_WAITEVALUTE = 3,
    /**
     *  @author cao, 15-08-22 14:08:18
     *
     *  完成评价
     */
    ENUM_MINE_ORDER_FINISHEVALUTE = 4,
    /**
     *  @author cao, 15-08-22 14:08:18
     *  
     *  完成交易
     */
    ENUM_MINE_ORDER_FINISHORDER = 5,
    /**
     *  @author cao, 15-08-22 16:08:27
     *
     *  我的订单列表分割线
     */
    ENUM_MINE_ORDER_SEPARATE = 6,
};
#endif
