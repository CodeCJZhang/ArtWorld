//
//  AW_FrogetPasswprdController.h
//  artWorld
//
//  Created by 曹学亮 on 15/10/21.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_FrogetPasswprdController : UIViewController
/**
 *  @author cao, 15-10-20 23:10:11
 *
 *  背景文本
 */
@property (weak, nonatomic) IBOutlet UITextField *background;
/**
 *  @author cao, 15-10-20 23:10:14
 *
 *  电话号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**
 *  @author cao, 15-10-20 23:10:17
 *
 *  背景文本
 */
@property (weak, nonatomic) IBOutlet UITextField *background2;
/**
 *  @author cao, 15-10-20 23:10:20
 *
 *  验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *VerificationNumber;
/**
 *  @author cao, 15-10-20 23:10:23
 *
 *  背景文本
 */
@property (weak, nonatomic) IBOutlet UITextField *background3;
/**
 *  @author cao, 15-10-20 23:10:26
 *
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passWord;
/**
 *  @author cao, 15-10-20 23:10:29
 *
 *  背景文本
 */
@property (weak, nonatomic) IBOutlet UITextField *background4;
/**
 *  @author cao, 15-10-20 23:10:32
 *
 *  确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
/**
 *  @author cao, 15-10-20 23:10:38
 *
 *  注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/**
 *  @author cao, 15-10-20 23:10:41
 *
 *  发送验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@end
