//
//  AW_ConfirmOrderOtherCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/12.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPlaceholderTextView.h"

@interface AW_ConfirmOrderOtherCell : UITableViewCell
/**
 *  @author cao, 15-09-12 09:09:15
 *
 *  快递费用
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryPrice;
/**
 *  @author cao, 15-09-12 09:09:54
 *
 *  给卖家留言textView
 */
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *leaveMessage;
/**
 *  @author cao, 15-09-12 09:09:58
 *
 *  使用优惠券按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *useCouponBtn;
/**
 *  @author cao, 15-09-12 19:09:54
 *
 *  点击使用优惠券后的回调
 */
@property (nonatomic,copy)void (^didClickUseCouponBtn)(NSInteger Index);
/**
 *  @author cao, 15-11-02 10:11:15
 *
 *  编辑完成后的回调
 */
@property(nonatomic,copy)void(^didEndEdite)(NSString * message);
/**
 *  @author cao, 15-11-02 10:11:29
 *
 *  留言信息
 */
@property(nonatomic,copy)NSString * Message;
/**
 *  @author cao, 15-09-12 09:09:22
 *
 *  索引
 */
@property(nonatomic)NSInteger index;
/**
 *  @author cao, 15-11-05 14:11:04
 *
 *  优惠券使用状态
 */
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end
