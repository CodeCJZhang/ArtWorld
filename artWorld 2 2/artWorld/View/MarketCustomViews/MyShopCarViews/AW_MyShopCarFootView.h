//
//  AW_MyShopCarFootView.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/25.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MyShopCarFootView : UIView

/**
 *  @author cao, 15-08-25 10:08:12
 *
 *  左侧选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/**
 *  @author cao, 15-08-25 10:08:23
 *
 *  商品的总价
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/**
 *  @author cao, 15-08-25 10:08:44
 *
 *  结算按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *payMentBtn;
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击底部视图选择按钮后的回调
 */
@property (nonatomic,copy)void (^didClickSelectBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-09 15:09:18
 *
 *  索引
 */
@property(nonatomic)NSInteger index;

@end
