//
//  AW_LoginInViewController.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/20.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_LoginInViewController : UIViewController
/**
 *  @author cao, 15-10-20 22:10:00
 *
 *  手机号背景图
 */
@property (weak, nonatomic) IBOutlet UITextField *backgroundTextField;
/**
 *  @author cao, 15-10-20 22:10:03
 *
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**
 *  @author cao, 15-10-20 22:10:05
 *
 *  密码背景图
 */
@property (weak, nonatomic) IBOutlet UITextField *pwdBackgroung;
/**
 *  @author cao, 15-10-20 22:10:09
 *
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passWord;
/**
 *  @author cao, 15-10-20 22:10:29
 *
 *  登陆按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginInBtn;

@end
