//
//  TYBasePageTabBar.m
//  TYSlidePageScrollViewDemo
//
//  Created by tanyang on 15/7/16.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "TYBasePageTabBar.h"

@interface TYBasePageTabBar ()
@property (nonatomic, weak) id<TYBasePageTabBarPrivateDelegate> praviteDelegate;
@end

@implementation TYBasePageTabBar

- (void)clickedPageTabBarAtIndex:(NSInteger)index
{
    if ([_praviteDelegate respondsToSelector:@selector(basePageTabBar:clickedPageTabBarAtIndex:)]) {
        [_praviteDelegate basePageTabBar:self clickedPageTabBarAtIndex:index];
    }
}
- (void)switchToPageIndex:(NSInteger)index
{
  
}

@end
