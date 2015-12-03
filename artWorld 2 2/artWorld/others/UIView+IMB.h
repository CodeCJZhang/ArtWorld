//
//  UIView+IMB.h
//  microtraining
//
//  Created by 闫建刚 on 14-7-10.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IMB)

/**
 *  创建圆形视图
 *
 *  @param borderWidth 边框宽度
 *  @param color       边框颜色
 *  @param imgName     内容图片
 */
- (void)circleWithBorderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor*)color
             contantImageName:(NSString*)imgName;

/**
 *  为视图添加边框
 *
 *  @param borderWidth 边框宽度
 *  @param color       边框颜色
 */
- (void)borderWithBorderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor*)color;

/**
 *  为视图添加圆角边框
 *
 *  @param borderWidth 边框宽度
 *  @param color       颜色
 *  @param radius      圆角半径
 */
- (void)borderWithBorderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)color
                       radius:(CGFloat)radius;

@end
