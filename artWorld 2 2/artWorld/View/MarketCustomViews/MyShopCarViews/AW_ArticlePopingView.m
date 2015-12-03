//
//  AW_ArticlePopingView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/19.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "AW_ArticlePopingView.h"
#import "AW_SelectColorDataSource.h"

@interface AW_ArticlePopingView()
/**
 *  @author cao, 15-09-18 18:09:03
 *
 *  选择颜色数据源
 */
@property(nonatomic,strong)AW_SelectColorDataSource * ColorDataSource;

@end

@implementation AW_ArticlePopingView

#pragma mark - Private Menthod
-(AW_ConfirmBtnView*)btnView{
    if (!_btnView) {
        _btnView = BundleToObj(@"AW_ConfirmBtnView");
    }
    return _btnView;
}

#pragma mark - LifeCycle Menthod
/**
 *  @author cao, 15-09-19 15:09:05
 *
 *  不使用xib的话一定要重写这个方法,加载其他的视图
 *
 *  @param frame 视图位置和大小
 *
 *  @return  view
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.6;
    //添加确定按钮视图
    [self addSubview:self.btnView];
 
    self.btnView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.btnView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:40]];
    //添加列表视图
    [self addSubview:self.colorTableView];
    self.colorTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.colorTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.colorTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.colorTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.btnView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.colorTableView addConstraint:[NSLayoutConstraint constraintWithItem:self.colorTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:300]];
}


@end
