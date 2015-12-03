//
//  IMB_AlertView.h
//  socialSecurity
//
//  Created by 张亚哲 on 15/6/29.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMB_AlertView : UIAlertView //测试

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message select:(void (^)(NSInteger index))select cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
