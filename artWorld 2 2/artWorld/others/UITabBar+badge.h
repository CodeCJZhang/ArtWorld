//
//  UITabBar+badge.h
//  socialSecurity
//
//  Created by 张亚哲 on 15/6/16.
//  Copyright (c) 2015年 张亚哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

/**
 *  显示小红点
 *
 *  @param index 第几个
 *  @param totalItem 一共几个item
 */
- (void)showBadgeOnIndex:(int)index totalItem:(int)totalItem;

/**
 *  隐藏小红点
 *
 *  @param index 第几个
 */
- (void)hideBadgeItemIndex:(int)index;

@end
