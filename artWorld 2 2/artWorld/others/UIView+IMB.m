//
//  UIView+IMB.m
//  microtraining
//
//  Created by 闫建刚 on 14-7-10.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import "UIView+IMB.h"
#import "IMB_Macro.h"

@implementation UIView (IMB)

- (void)circleWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color contantImageName:(NSString *)imgName{
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [color CGColor];
    if (imgName) {
        self.layer.contents = (id)[IMAGE(imgName) CGImage];
    }
} // 创建圆形视图

- (void)borderWithBorderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor*)color{
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [color CGColor];
} // 为视图添加边框

- (void)borderWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color radius:(CGFloat)radius{
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}

// 为视图添加圆角边框


@end
