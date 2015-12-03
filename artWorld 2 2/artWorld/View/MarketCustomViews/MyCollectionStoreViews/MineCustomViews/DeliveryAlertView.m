//
//  DeliveryAlertView.m
//  artWorld
//
//  Created by 曹学亮 on 15/9/2.
//  Copyright (c) 2015年 张晓旭. All rights reserved.
//

#import "DeliveryAlertView.h"

@interface DeliveryAlertView()
/**
 *  @author cao, 15-09-02 14:09:10
 *
 *  黑色背景视图
 */
@property(nonatomic,strong)UIView * backGroundView;

@end

@implementation DeliveryAlertView

-(instancetype)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backGroundView = [[UIView alloc]initWithFrame:self.frame];
        self.backGroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.backGroundView];
    }
    return self;
}

-(void)setContentView:(UIView *)contentView{
    _contentView =  contentView;
    _contentView.center = self.center;
    [self addSubview:contentView];
}
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [subView addSubview:self];
        [self showBackground];
        [self showAlertAnimation];
    }
}

-(void)showWithoutAnimation{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [self showBackground];
        [subView addSubview:self];
        _contentView.alpha = 0;
        self.backGroundView.alpha = 0;
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations:^{
            _contentView.alpha = 1;
            self.backGroundView.alpha = 0.4;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hide {
    [self hideAlertAnimation];
}

-(void)hideWithoutAnimation{
    self.backGroundView.alpha = 4;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.15];
    self.backGroundView.alpha = 0;
    [UIView commitAnimations];
    _contentView.alpha = 1;
    self.backGroundView.alpha = 0.4;
    //设置动画时间为0.45秒,xy方向缩放的最终值为1
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations:^{
        _contentView.alpha = 0;
        self.backGroundView.alpha = 0;
    } completion:^(BOOL finished) {
        //动画完成后再从父视图中删除
        [self removeFromSuperview];
    }];
}
- (void)showBackground
{
    self.backGroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.15];
    self.backGroundView.alpha = 0.4;
    [UIView commitAnimations];
}

-(void)showAlertAnimation
{
    _contentView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    self.backGroundView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    _contentView.alpha = 0;
    self.backGroundView.alpha = 0;
    //设置动画时间为0.45秒,xy方向缩放的最终值为1
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:0 animations:^{
        _contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        self.backGroundView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        _contentView.alpha = 1;
        self.backGroundView.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideAlertAnimation {
    _contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.backGroundView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    _contentView.alpha = 1;
    self.backGroundView.alpha = 0.4;
    //设置动画时间为0.45秒,xy方向缩放的最终值为1
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:0 animations:^{
        _contentView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        self.backGroundView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        _contentView.alpha = 0;
        self.backGroundView.alpha = 0;
    } completion:^(BOOL finished) {
        //动画完成后再从父视图中删除
        [self removeFromSuperview];
    }];
}

@end
