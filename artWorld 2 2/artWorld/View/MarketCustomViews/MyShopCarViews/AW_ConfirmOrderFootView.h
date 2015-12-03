//
//  AW_ConfirmOrderFootView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/11.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_ConfirmOrderFootView : UIView
/**
 *  @author cao, 15-09-11 19:09:01
 *
 *  商品总价格
 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
/**
 *  @author cao, 15-09-11 19:09:19
 *
 *  提交订单按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmOrderBtn;

@end
