//
//  ScaleAnimation.m
//  VCTransitions
//
//  Created by Tyler Tillage on 9/2/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "ScaleAnimation.h"

@interface ScaleAnimation() {
    CGFloat _startScale, _completionSpeed;
    id<UIViewControllerContextTransitioning> _context;
    UIView *_transitioningView;
}

@end

@implementation ScaleAnimation

@synthesize viewForInteraction = _viewForInteraction;

-(instancetype)initWithNavigationController:(UINavigationController *)controller {
    self = [super init];
    if (self) {
        self.navigationController = controller;
        _completionSpeed = 0.2;
        //_pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    }
    return self;
}

#pragma mark - Animated Transitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //获得容器视图的引用
    UIView *containerView = [transitionContext containerView];
    //获得from试图控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //获得to视图控制器
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.type == AnimationTypePresent) {
       //将“to“视图添加到"from"视图的上面(将to视图添加到容器视图上面)
        toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.alpha = 0.3;
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        //进行仿射变换
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished){
            [transitionContext completeTransition:YES];
        }];
    } else if (self.type == AnimationTypeDismiss) {
       //将“to“视图添加到"from"视图的下面(将to视图插入到容器视图)
        fromViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        fromViewController.view.alpha = 1.0;
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        //进行仿射变换
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
            fromViewController.view.alpha = 0.3;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

//设置动画持续的时间
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

@end
