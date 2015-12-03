//
//  AW_DeliveryAdressCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/1.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author cao, 15-09-01 16:09:53
 *
 *  收货地址cell
 */
@interface AW_DeliveryAdressCell : UITableViewCell
/**
 *  @author cao, 15-09-01 17:09:32
 *
 *  收货人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryPerson;
/**
 *  @author cao, 15-09-01 17:09:43
 *
 *  收货地址
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryAdress;
/**
 *  @author cao, 15-09-01 17:09:50
 *
 *  收货人电话号码
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryPhoneNumber;
/**
 *  @author cao, 15-09-01 17:09:07
 *
 *  设置为默认地址按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *defltBtn;
/**
 *  @author cao, 15-09-01 17:09:28
 *
 *  编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *editeBtn;
/**
 *  @author cao, 15-09-01 17:09:36
 *
 *  删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/**
 *  @author cao, 15-09-01 17:09:50
 *
 *  默认收货地址背景图片按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *defealtImageBtn;
/**
 *  @author cao, 15-09-07 16:09:18
 *
 *  盛放内容的视图
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击编辑按钮回调
 */
@property (nonatomic,copy)void (^didClickEditeBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击设为默认地址按钮回调
 */
@property (nonatomic,copy)void (^didClickDefaultBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  点击删除按钮回调
 */
@property (nonatomic,copy)void (^didClickDeleteBtn)(NSInteger Index);
/**
 *  @author cao, 15-09-01 19:09:25
 *
 *  索引
 */
@property (nonatomic,assign)NSInteger Index;

@end
