//
//  UITabBar+badge.m
//  socialSecurity
//
//  Created by 张亚哲 on 15/6/16.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import "UITabBar+badge.h"

@implementation UITabBar (badge)

/**
 *  显示小红点
 *
 *  @param index 第几个
 */
- (void)showBadgeOnIndex:(int)index totalItem:(int)totalItem{
    [self removeBadgeOnItemIndex:index];
    // 创建标记视图
    UIView *badgeView = [[UIView alloc]init];
    // 为标记视图创建唯一标示符
    badgeView.tag = 100 + index;
    // 设置标记视图圆角
    badgeView.layer.cornerRadius = 3;
    // 设置标记视图颜色
    badgeView.backgroundColor = [UIColor redColor];
    
    /* --------- 标记视图位置算法 ⬇️--------------*/
    CGRect tabFrame = self.frame;
    float percentX = (index + 0.6)/ totalItem;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.15 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 6, 6);
    /* --------- 标记视图位置算法 ⬆️--------------*/
    
    [self addSubview:badgeView];
}

/**
 *  隐藏小红点
 *
 *  @param index 第几个
 */
- (void)hideBadgeItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView *subView in self.subviews) {
        if (subView.tag == 100 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
