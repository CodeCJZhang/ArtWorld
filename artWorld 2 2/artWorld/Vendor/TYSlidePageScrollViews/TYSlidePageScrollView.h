//
//  TYSlidePageScrollView.h
//  TYSlidePageScrollViewDemo
//
//  Created by tanyang on 15/7/16.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYBasePageTabBar.h"
#import "AW_TarBarView.h"

@class TYSlidePageScrollView;

typedef NS_ENUM(NSUInteger, TYPageTabBarState) {
    TYPageTabBarStateStopOnTop,
    TYPageTabBarStateScrolling,
    TYPageTabBarStateStopOnButtom,
};

@protocol TYSlidePageScrollViewDataSource <NSObject>

@required

// num of pageViews
- (NSInteger)numberOfPageViewOnSlidePageScrollView;
/**
 *  @author cao, 15-08-24 17:08:17
 *
 *  子视图需要继承UIScrollView，并且垂直滚动，
 *
 *  @param slidePageScrollView 父视图
 *  @param index               索引位置
 *
 *  @return
 */
- (UIScrollView *)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index;

@end

@protocol TYSlidePageScrollViewDelegate <NSObject>

@optional

/**
 *  @author cao, 15-08-24 17:08:13
 *
 *  子视图垂直滚动的时候调用（contentOfSet改变的时候）
 *
 *  @param slidePageScrollView 父scrollview
 *  @param pageScrollView      子视图scrollview
 */
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView verticalScrollViewDidScroll:(UIScrollView *)pageScrollView;

/**
 *  @author cao, 15-08-24 17:08:20
 *
 *  tarBar垂直滚动以及他的状态
 *
 *  @param slidePageScrollView
 *  @param offset              tarbar位置
 *  @param state               tarBar的状态
 */
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageTabBarScrollOffset:(CGFloat)offset state:(TYPageTabBarState)state;

/**
 *  @author cao, 15-08-24 17:08:42
 *
 *  horizen scroll to pageIndex, when index change will call（切换视图时调用）
 *
 *  @param slidePageScrollView
 *  @param index
 */
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView horizenScrollToPageIndex:(NSInteger)index;
/**
 *  @author cao, 15-08-24 17:08:57
 *
 *  horizen scroll any offset changes will call
 *
 *  @param slidePageScrollView
 *  @param scrollView
 */
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView horizenScrollViewDidScroll:(UIScrollView *)scrollView;
/**
 *  @author cao, 15-08-24 17:08:24
 *
 *   horizen scroll Begin Dragging
 *
 *  @param slidePageScrollView
 *  @param scrollView
 */
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView horizenScrollViewWillBeginDragging:(UIScrollView *)scrollView;

/**
 *  @author cao, 15-08-24 17:08:51
 *
 *   horizen scroll called when scroll view grinds to a halt
 *
 *  @param slidePageScrollView
 *  @param scrollView          
 */
- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView horizenScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end


@interface TYSlidePageScrollView : UIView

@property (nonatomic, weak)   id<TYSlidePageScrollViewDataSource> dataSource;
@property (nonatomic, weak)   id<TYSlidePageScrollViewDelegate> delegate;

@property (nonatomic, assign) BOOL automaticallyAdjustsScrollViewInsets; // default NO;(iOS 7) it will setup viewController automaticallyAdjustsScrollViewInsets, because this property (YES) cause scrollView layout no correct
/**
 *  @author cao, 15-09-24 14:09:46
 *
 *  头视图
 */
@property (nonatomic, strong) UIView *headerView;
#warning 修改了分段视图
//@property (nonatomic, strong) TYBasePageTabBar *pageTabBar; //defult nil
/**
 *  @author cao, 15-09-24 14:09:40
 *
 *  选择tarBar
 */
@property(nonatomic,strong)AW_TarBarView * pageTabBar;
/**
 *  @author cao, 15-09-24 14:09:01
 *
 *  tarBar是否停在上部(默认值是YES)
 */
@property (nonatomic, assign) BOOL pageTabBarIsStopOnTop;
/**
 *  @author cao, 15-09-24 14:09:13
 *
 *  tarBar停在顶部的高度(if pageTabBarIsStopOnTop is NO ,this property is inValid,默认值是0)
 */
@property (nonatomic, assign) CGFloat pageTabBarStopOnTopHeight;
/**
 *  @author cao, 15-09-24 14:09:12
 *
 *  当前选中的页数
 */
@property (nonatomic, assign, readonly) NSInteger curPageIndex;
/**
 *  @author cao, 15-09-24 14:09:45
 *
 *  当滚动到scroll宽度的百分之多少 改变index(默认值为0.5)
 */
@property (nonatomic, assign) CGFloat changeToNextIndexWhenScrollToWidthOfPercent;
/**
 *  @author cao, 15-08-24 17:08:45
 *
 *  容器视图Y侧约束
 */
@property (nonatomic, strong) NSLayoutConstraint *headerContentYConstraint;

- (void)reloadData;

- (void)scrollToPageIndex:(NSInteger)index animated:(BOOL)animated;

- (UIScrollView *)pageScrollViewForIndex:(NSInteger)index;

- (NSInteger)indexOfPageScrollView:(UIScrollView *)pageScrollView;

@end
