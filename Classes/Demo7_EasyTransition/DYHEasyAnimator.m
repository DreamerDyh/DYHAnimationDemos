//
//  DYHEasyAnimator.m
//  DYHAnimationDemos
//
//  Created by Dai Yunhao on 2017/5/16.
//  Copyright © 2017年 Dai Yunhao. All rights reserved.
//

#import "DYHEasyAnimator.h"

@implementation DYHEasyAnimator

-  (instancetype)initWithIsPush:(BOOL)isPush
{
    if (self = [super init]) {
        self.isPush = isPush;
    }
    return self;
}

+ (instancetype)animatorWithIsPush:(BOOL)isPush
{
    return [[self alloc] initWithIsPush:isPush];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGAffineTransform bottomTransForm = CGAffineTransformMakeTranslation(0, CGRectGetHeight(fromViewController.view.bounds));
    CGAffineTransform topTransForm = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(fromViewController.view.bounds));
    
    if (self.isPush) {
        
        toViewController.view.transform = bottomTransForm;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f usingSpringWithDamping:1.2f initialSpringVelocity:0.1f options:0 animations:^{
            fromViewController.view.transform = topTransForm;
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        
        toViewController.view.transform = topTransForm;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f usingSpringWithDamping:1.2f initialSpringVelocity:0.1f options:0 animations:^{
            fromViewController.view.transform = bottomTransForm;
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
