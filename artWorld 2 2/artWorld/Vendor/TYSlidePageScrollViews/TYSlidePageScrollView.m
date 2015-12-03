//
//  TYSlidePageScrollView.m
//  TYSlidePageScrollViewDemo
//
//  Created by tanyang on 15/7/16.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "TYSlidePageScrollView.h"
#import "UIScrollView+ty_swizzle.h"
#import "AW_Constants.h"

@interface TYBasePageTabBar ()
@property (nonatomic, weak) id<TYBasePageTabBarPrivateDelegate> praviteDelegate;
@end

@interface TYSlidePageScrollView ()<UIScrollViewDelegate,TYBasePageTabBarPrivateDelegate>{
    struct {
        unsigned int horizenScrollToPageIndex   :1;
        unsigned int horizenScrollViewDidScroll :1;
        unsigned int horizenScrollViewDidEndDecelerating :1;
        unsigned int horizenScrollViewWillBeginDragging :1;
        unsigned int verticalScrollViewDidScroll :1;
        unsigned int pageTabBarScrollOffset :1;
    }_delegateFlags;
}
/**
 *  @author cao, 15-08-24 17:08:10
 *
 *  水平滚动视图
 */
@property (nonatomic, weak) UIScrollView *horScrollView;
/**
 *  @author cao, 15-08-24 17:08:48
 *
 *  盛放headView和tarBar的容器视图
 */
@property (nonatomic, strong) UIView *headerContentView;
/**
 *  @author cao, 15-08-24 17:08:29
 *
 *  子视图的数组
 */
@property (nonatomic, strong) NSArray *pageViewArray;
/**
 *  @author cao, 15-09-25 10:09:19
 *
 *  上部容器视图总高度
 */
@property(nonatomic)float headerContenViewHeight;
@end

@implementation TYSlidePageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setPropertys];
        
        [self addHorScrollView];
        
        [self addHeaderContentView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setPropertys];
        
        [self addHorScrollView];
        
        [self addHeaderContentView];
    }
    return self;
}

#pragma mark - setter getter

- (void)setPropertys
{
    _curPageIndex = 0;
    _pageTabBarStopOnTopHeight = 0;
    _pageTabBarIsStopOnTop = YES;
    _automaticallyAdjustsScrollViewInsets = NO;
    _changeToNextIndexWhenScrollToWidthOfPercent = 0.5;
}

/**
 *  @author cao, 15-08-19 12:08:06
 *
 *  销毁后调用
 */
- (void)resetPropertys{
    //写下面这两行代码(当点击展示详情按钮时,子视图垂直滚动时,不能进行监听)
    [self addPageViewKeyPathOffsetWithOldIndex:_curPageIndex newIndex:-1];
    _curPageIndex = self.pageTabBar.currentIndex;
    //容器视图的约束全部删除移除(否则tarBar上的按钮不能点击)
    [self.headerContentView.constraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.headerContentView removeConstraint:obj];
    }];
    [_headerContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_pageViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == _headerContentView ||constraint.firstItem == _horScrollView) {
            [self removeConstraint:constraint];
        }
    }
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setViewControllerAdjustsScrollView
{
    UIViewController *viewController = [self viewController];
    if ([viewController respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        viewController.automaticallyAdjustsScrollViewInsets = _automaticallyAdjustsScrollViewInsets;
    }
}

- (void)setDelegate:(id<TYSlidePageScrollViewDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateFlags.horizenScrollToPageIndex = [delegate respondsToSelector:@selector(slidePageScrollView:horizenScrollToPageIndex:)];
    _delegateFlags.horizenScrollViewDidScroll = [delegate respondsToSelector:@selector(slidePageScrollView:horizenScrollViewDidScroll:)];
    _delegateFlags.horizenScrollViewDidEndDecelerating = [delegate respondsToSelector:@selector(slidePageScrollView:horizenScrollViewDidEndDecelerating:)];
    _delegateFlags.horizenScrollViewWillBeginDragging = [delegate respondsToSelector:@selector(slidePageScrollView:horizenScrollViewWillBeginDragging:)];
    _delegateFlags.verticalScrollViewDidScroll = [delegate respondsToSelector:@selector(slidePageScrollView:verticalScrollViewDidScroll:)];
    _delegateFlags.pageTabBarScrollOffset = [delegate respondsToSelector:@selector(slidePageScrollView:pageTabBarScrollOffset:state:)];
}

#pragma mark - add subView

- (void)addHorScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    _horScrollView = scrollView;
    /**
     *  @author cao, 15-08-20 08:08:54
     *
     *  取消显示水平滚动条和竖直滚动条
     */
    _horScrollView.showsHorizontalScrollIndicator = NO;
    _horScrollView.showsVerticalScrollIndicator = NO;
    /**
     *  @author cao, 15-08-20 15:08:10
     *
     *  取消回弹效果
     */
    _horScrollView.bounces = NO;
}

- (void)addHeaderContentView
{
    UIView *headerContentView = [[UIView alloc]init];
    [self addSubview:headerContentView];
    _headerContentView = headerContentView;
}

#pragma mark - private method

- (void)updateHeaderContentView
{
    if (_headerView) {
        [_headerContentView addSubview:_headerView];
    }
    
    if (_pageTabBar) {
        _pageTabBar.praviteDelegate = self;
        [_headerContentView addSubview:_pageTabBar];
    }
}

- (void)layoutHeaderContentView
{
    _headerContentView.translatesAutoresizingMaskIntoConstraints = NO;
    /**
     *  @author cao, 15-08-19 11:08:43
     *
     *  containView添加约束
     */
    _headerContentYConstraint = [NSLayoutConstraint constraintWithItem:_headerContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_headerContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:_headerContentYConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_headerContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    self.headerContenViewHeight = CGRectGetHeight(_headerView.frame)+CGRectGetHeight(_pageTabBar.frame);
    //重新插入约束
    [_headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:_headerContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:self.headerContenViewHeight]];
    NSLog(@"容器顶部约束====%f====",self.headerContenViewHeight);
    NSLog(@"%@",_headerContentView.constraints);
    if (_headerView) {
        /**
         *  @author cao, 15-08-19 11:08:23
         *
         *  headView添加约束
         */
        _headerView.translatesAutoresizingMaskIntoConstraints = NO;
        [_headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_headerContentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [_headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headerContentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [_headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_headerContentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
            [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:CGRectGetHeight(_headerView.frame)]];
        NSLog(@"=====%@=====",NSStringFromCGRect(_headerView.frame));
 }

    if (_pageTabBar) {
        /**
         *  @author cao, 15-08-19 11:08:48
         *
         *  分段按钮约束
         */
        _pageTabBar.translatesAutoresizingMaskIntoConstraints = NO;
        [_headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:_pageTabBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_headerContentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [_headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:_pageTabBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headerView ? _headerView:_headerContentView attribute:_headerView ? NSLayoutAttributeBottom:NSLayoutAttributeTop multiplier:1 constant:0]];
        [_headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:_pageTabBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_headerContentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
            [_pageTabBar addConstraint:[NSLayoutConstraint constraintWithItem:_pageTabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:CGRectGetHeight(_pageTabBar.frame)]];
        NSLog(@"=====%@=====",NSStringFromCGRect(_pageTabBar.frame));
    }
}


- (void)updatePageViews
{
    NSInteger pageNum = [_dataSource numberOfPageViewOnSlidePageScrollView];
    NSMutableArray *scrollViewArray = [NSMutableArray arrayWithCapacity:pageNum];
    for (NSInteger index = 0; index < pageNum; ++index) {
        UIScrollView *pageVerScrollView = [_dataSource slidePageScrollView:self pageVerticalScrollViewForIndex:index];
        [_horScrollView addSubview:pageVerScrollView];
        [scrollViewArray addObject:pageVerScrollView];
    }
    
    _pageViewArray = [scrollViewArray copy];
}

/**
 *  @author cao, 15-08-19 11:08:18
 *
 *  布局水平滚动视图
 */

#warning 布局水平滚动视图
- (void)layoutPageViews
{
    _horScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_horScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_horScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_horScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_horScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    CGFloat headerContentViewHieght = CGRectGetHeight(_headerView.frame)+CGRectGetHeight(_pageTabBar.frame);
    NSLog(@"====%f===",headerContentViewHieght);
    
    __block UIScrollView *prePageView = nil;
    for (UIScrollView *pageVerScrollView in _pageViewArray) {
        pageVerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        if (prePageView) {
            //左侧约束
            [_horScrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageVerScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:prePageView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }else {
            //
            [_horScrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageVerScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_horScrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        }
        prePageView = pageVerScrollView;
        
       //pageVerScrollView上部约束
        [_horScrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageVerScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_horScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        //pageVerScrollView高度约束
        [_horScrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageVerScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_horScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        //pageVerScrollView宽度约束
        [_horScrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageVerScrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_horScrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        //pageVerScrollView内容大小
#warning 注意。。。。。
        pageVerScrollView.contentInset = UIEdgeInsetsMake(headerContentViewHieght, 0, 0, 0);
        NSLog(@"====%f=====",headerContentViewHieght);
        pageVerScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(headerContentViewHieght, 0, 0, 0);
    };
    //_horScrollView添加右侧约束
    [_horScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_horScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:prePageView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    //_horScrollView内容大小
    _horScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*_pageViewArray.count, 0);
}

-(void)addPageViewKeyPathOffsetWithOldIndex:(NSInteger)oldIndex newIndex:(NSInteger)newIndex
{
    if (oldIndex == newIndex) {
        return;
    }
    if (oldIndex >= 0 && oldIndex < _pageViewArray.count) {
        [_pageViewArray[oldIndex] removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
    if (newIndex >= 0 && newIndex < _pageViewArray.count) {
        [_pageViewArray[newIndex] addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        //将其改为YES当点击展示个人详情时(子scrollowView的contentOffSet会跟着自动改变)
        [self pageScrollViewDidScroll:object changeOtherPageViews:YES];
        //[self pageScrollViewDidScroll:object changeOtherPageViews:NO];
    }
}

- (CGFloat)scrollViewMinContentSizeHeight
{
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat pageTabBarHieght = CGRectGetHeight(_pageTabBar.frame);

    NSInteger scrollMinContentSizeHeight = viewHeight - (pageTabBarHieght + _pageTabBarStopOnTopHeight );
    
    if (!_pageTabBarIsStopOnTop) {
        scrollMinContentSizeHeight = viewHeight;
    }
    return scrollMinContentSizeHeight;
}

- (void)dealPageScrollView:(UIScrollView *)pageScrollView minContentSizeHeight:(CGFloat)minContentSizeHeight{
    pageScrollView.minContentSizeHeight = minContentSizeHeight;
    if (pageScrollView.contentSize.height < minContentSizeHeight) {
        pageScrollView.contentSize = CGSizeMake(pageScrollView.contentSize.width, minContentSizeHeight);
    }
}

- (void)dealAllPageScrollViewMinContentSize
{
    NSInteger minContentSizeHeight = [self scrollViewMinContentSizeHeight];
    // 处理所有scrollView的最小的contentsize
    for (UIScrollView *pageView in _pageViewArray) {
        [self dealPageScrollView:pageView minContentSizeHeight:minContentSizeHeight];
    }
}
//改变所有scrollowView的contentOffSet
- (void)changeAllPageScrollViewOffsetY:(CGFloat)offsetY isOnTop:(BOOL)isOnTop
{
    [_pageViewArray enumerateObjectsUsingBlock:^(UIScrollView *pageScrollView, NSUInteger idx, BOOL *stop) {
        if (idx != _curPageIndex && !(isOnTop && pageScrollView.contentOffset.y > offsetY)) {
            [pageScrollView setContentOffset:CGPointMake(pageScrollView.contentOffset.x, offsetY)];
            NSLog(@"===%f===",offsetY);
        }
    }];
}

- (void)resetPageScrollViewContentOffset{
    if (_curPageIndex >= 0 && _curPageIndex < _pageViewArray.count) {
        UIScrollView *pagescrollView = _pageViewArray[_curPageIndex];
        pagescrollView.contentOffset = CGPointMake(pagescrollView.contentOffset.x, -(CGRectGetHeight(_headerView.frame)+CGRectGetHeight(_pageTabBar.frame)));
        NSLog(@"===%f===",pagescrollView.contentOffset.y);
    }
}

#pragma mark - public method

- (void)reloadData
{
    [self resetPropertys];
    
    [self setViewControllerAdjustsScrollView];
    
    [self updateHeaderContentView];
    
    [self layoutHeaderContentView];

    [self updatePageViews];
    
    [self layoutPageViews];
    
    [self addPageViewKeyPathOffsetWithOldIndex:-1 newIndex:_curPageIndex];
    
    [self dealAllPageScrollViewMinContentSize];
    
    [self resetPageScrollViewContentOffset];
}

- (void)scrollToPageIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index < 0 || index >= _pageViewArray.count) {
        NSLog(@"scrollToPageIndex index illegal");
        return;
    }
    [self pageScrollViewDidScroll:_pageViewArray[_curPageIndex] changeOtherPageViews:YES];
    [_horScrollView setContentOffset:CGPointMake(index * CGRectGetWidth(_horScrollView.frame), 0) animated:animated];
}

- (UIScrollView *)pageScrollViewForIndex:(NSInteger)index
{
    if (index < 0 || index >= _pageViewArray.count) {
        NSLog(@"pageScrollViewForIndex index illegal");
        return nil;
    }
    return _pageViewArray[index];
}

- (NSInteger)indexOfPageScrollView:(UIScrollView *)pageScrollView
{
    return [_pageViewArray indexOfObject:pageScrollView];
}

#pragma mark - delegate
// horizen scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegateFlags.horizenScrollViewWillBeginDragging) {
        [_delegate slidePageScrollView:self horizenScrollViewWillBeginDragging:scrollView];
    }
    [self pageScrollViewDidScroll:_pageViewArray[_curPageIndex] changeOtherPageViews:YES];
}

//水平滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegateFlags.horizenScrollViewDidScroll) {
        [_delegate slidePageScrollView:self horizenScrollViewDidScroll:_horScrollView];
    }
    
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame) + _changeToNextIndexWhenScrollToWidthOfPercent);
    
    if (_curPageIndex != index) {
        if (index >= _pageViewArray.count) {
            index = _pageViewArray.count-1;
        }
        if (index < 0) {
            index = 0;
        }
        
        [self addPageViewKeyPathOffsetWithOldIndex:_curPageIndex newIndex:index];
        _curPageIndex = index;
        
        if (_pageTabBar) {
            [_pageTabBar switchToPageIndex:_curPageIndex];
        }
        if (_delegateFlags.horizenScrollToPageIndex) {
            [_delegate slidePageScrollView:self horizenScrollToPageIndex:_curPageIndex];
        }
    }
}

// page scrollView
- (void)pageScrollViewDidScroll:(UIScrollView *)pageScrollView changeOtherPageViews:(BOOL)isNeedChange{
    if (_delegateFlags.verticalScrollViewDidScroll) {
        [_delegate slidePageScrollView:self verticalScrollViewDidScroll:pageScrollView];
    }
     CGFloat headerContenViewHeight = CGRectGetHeight(_headerView.frame)+CGRectGetHeight(_pageTabBar.frame);
    //CGFloat headerContentViewheight = CGRectGetHeight(_headerContentView.frame);
    NSLog(@"===%f====",_headerContentView.frame.size.height);
    NSLog(@"===%f===",_headerContentYConstraint.constant);
    CGFloat pageTabBarHieght = CGRectGetHeight(_pageTabBar.frame);
    
    NSInteger pageTabBarIsStopOnTop = _pageTabBarStopOnTopHeight;
    if (!_pageTabBarIsStopOnTop) {
        pageTabBarIsStopOnTop = - pageTabBarHieght;
    }
    NSLog(@"contentOffSet:====%f=====",pageScrollView.contentOffset.y);
    CGFloat offsetY = pageScrollView.contentOffset.y;
    if (offsetY <= -headerContenViewHeight){
        // headerContentView full show
        if (_headerContentYConstraint.constant != 0) {
            _headerContentYConstraint.constant = 0;
            if (_delegateFlags.pageTabBarScrollOffset) {
                [_delegate slidePageScrollView:self pageTabBarScrollOffset:offsetY state:TYPageTabBarStateStopOnButtom];
            }
        }
        if (isNeedChange) {
            [self changeAllPageScrollViewOffsetY:-headerContenViewHeight isOnTop:NO];
        }
    }else if (offsetY < -pageTabBarHieght - pageTabBarIsStopOnTop) {
        // scroll headerContentView(上部容器视图随着scrollowView的滚动而滚动)
        _headerContentYConstraint.constant = -(offsetY+headerContenViewHeight);
        if (_delegateFlags.pageTabBarScrollOffset) {
            [_delegate slidePageScrollView:self pageTabBarScrollOffset:offsetY state:TYPageTabBarStateScrolling];
        }
        if (isNeedChange) {
            [self changeAllPageScrollViewOffsetY:pageScrollView.contentOffset.y isOnTop:NO];
        }
    }else {
        // pageTabBar on the top
        if (_headerContentYConstraint.constant != -headerContenViewHeight+pageTabBarHieght + pageTabBarIsStopOnTop){
            NSLog(@"===%f===",headerContenViewHeight);
            _headerContentYConstraint.constant = -headerContenViewHeight+pageTabBarHieght + pageTabBarIsStopOnTop;

            if (_delegateFlags.pageTabBarScrollOffset) {
                [_delegate slidePageScrollView:self pageTabBarScrollOffset:offsetY state:TYPageTabBarStateStopOnTop];
            }
        }
        if (isNeedChange) {
            [self changeAllPageScrollViewOffsetY:-pageTabBarHieght-pageTabBarIsStopOnTop isOnTop:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_delegateFlags.horizenScrollViewDidEndDecelerating) {
        [_delegate slidePageScrollView:self horizenScrollViewDidEndDecelerating:_horScrollView];
    }
}

- (void)basePageTabBar:(TYBasePageTabBar *)basePageTabBar clickedPageTabBarAtIndex:(NSInteger)index
{
    [self scrollToPageIndex:index animated:NO];
}

-(void)dealloc
{
    [self resetPropertys];
}

@end
