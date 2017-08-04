//
//  BAlertAnimator.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BAlertAnimator.h"
#import "BAlertController.h"

@implementation BAlertAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        [self presentAnimated:transitionContext];
    } else {
        [self dismissAnimated:transitionContext];
    }
}

- (void)presentAnimated:(id<UIViewControllerContextTransitioning>)transitionContext
{
    BAlertController *toVC = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext.containerView addSubview:toVC.view];
    
    toVC.view.alpha = 0;
    toVC.alertView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.7 initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            toVC.view.alpha = 1;
                            toVC.alertView.transform = CGAffineTransformMakeScale(1, 1);
                        } completion:^(BOOL finished) {
                            
                            [transitionContext completeTransition:YES];
                        }];
}

- (void)dismissAnimated:(id<UIViewControllerContextTransitioning>)transitionContext
{
    BAlertController *fromVC = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.view.alpha = 1;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.7 initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            fromVC.view.alpha = 0;
                            fromVC.alertView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                        } completion:^(BOOL finished) {
                            
                            [transitionContext completeTransition:YES];
                        }];
}

@end
