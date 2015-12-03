//
//  AW_FavobleView.h
//  artWorld
//
//  Created by 曹学亮 on 15/9/21.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_FavobleView : UIView
/** *  @author cao, 15-09-21 14:09:49
 *
 *  输入验证码文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *privilegeNumber;
/**
 *  @author cao, 15-09-21 14:09:10
 *
 *  确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/**
 *  @author cao, 15-09-21 14:09:34
 *
 *  点击确定按钮的回调
 */
@property(nonatomic,copy)void(^didClickedConfirmBtn)(NSString * privilegeString);
/**
 *  @author cao, 15-09-21 14:09:19
 *
 *  店铺优惠码
 */
@property(nonatomic,copy)NSString *privilegeString;

@end
