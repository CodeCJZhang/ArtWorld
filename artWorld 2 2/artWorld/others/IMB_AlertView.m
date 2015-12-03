//
//  IMB_AlertView.m
//  socialSecurity
//
//  Created by 张亚哲 on 15/6/29.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import "IMB_AlertView.h"

@interface IMB_AlertView ()<UIAlertViewDelegate>

@property (nonatomic,copy)void (^didSelect)(NSInteger index);

@end

@implementation IMB_AlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message select:(void (^)(NSInteger index))select cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    if (self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]) {
        if (select) {
            _didSelect = select;
        }
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_didSelect) {
        _didSelect(buttonIndex);
    }
}

@end
