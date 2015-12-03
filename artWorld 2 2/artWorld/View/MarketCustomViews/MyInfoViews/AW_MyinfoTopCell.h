//
//  AW_MyinfoTopCell.h
//  artWorld
//
//  Created by 曹学亮 on 15/8/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_MyinfoTopCell : UITableViewCell

/**
 *  @author cao, 15-08-21 14:08:34
 *
 *  我的头像
 */
@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;
/**
 *  @author cao, 15-08-21 14:08:51
 *
 *  我的名字
 */
@property (weak, nonatomic) IBOutlet UITextField *nameText;
/**
 *  @author cao, 15-08-21 14:08:00
 *
 *  我的电话
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**
 *  @author cao, 15-08-21 14:08:09
 *
 *  收货地址
 */
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
/**
 *  @author cao, 15-09-01 18:09:31
 *
 *  修改密码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *changePasswordBtn;
/**
 *  @author cao, 15-09-01 19:09:47
 *
 *  收货地址按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deliveryAdressBtn;
/**
 *  @author cao, 15-09-01 19:09:25
 *
 *  索引
 */
@property (nonatomic,assign)NSInteger index;
/**
 *  @author cao, 15-09-01 19:09:54
 *
 *  回调的block块
 */
@property (nonatomic,copy)void (^selectKindBtn)(NSInteger index);
/**
 *  @author cao, 15-11-07 16:11:53
 *
 *  编辑我的昵称时的回调
 */
@property(nonatomic,copy)void(^didEditeNickName)(NSString * nickName);
/**
 *  @author cao, 15-11-07 16:11:55
 *
 *  昵称
 */
@property(nonatomic,copy)NSString * nickName;
@end
