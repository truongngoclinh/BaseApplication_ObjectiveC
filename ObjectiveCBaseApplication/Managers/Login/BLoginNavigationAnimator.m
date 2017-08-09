//
//  BLoginNavigationAnimator.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BLoginNavigationAnimator.h"
#import "BAuthBaseViewController.h"

@implementation BLoginNavigationAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPush) {
        return 0.8;
    } else {
        return 1.0;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    BAuthBaseViewController *toVC = (BAuthBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    BAuthBaseViewController *fromVC = (BAuthBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (self.isPush) {

        [fromVC prepareAnimationForTransitionType:kLoginNavigationAnimationTypeNewVCOnTop];
        [toVC prepareAnimationForTransitionType:kLoginNavigationAnimationTypePushed];
        
        [transitionContext.containerView addSubview:toVC.view];
        [transitionContext.containerView layoutIfNeeded];
        
    } else {
        
        [fromVC prepareAnimationForTransitionType:kLoginNavigationAnimationTypePoped];
        [toVC prepareAnimationForTransitionType:kLoginNavigationAnimationTypeNewVCRemoved];
        
        [transitionContext.containerView insertSubview:toVC.view belowSubview:fromVC.view];
        [transitionContext.containerView layoutIfNeeded];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         if (self.isPush) {
                             [fromVC performAnimationForTransitionType:kLoginNavigationAnimationTypeNewVCOnTop];
                             [toVC performAnimationForTransitionType:kLoginNavigationAnimationTypePushed];
                         } else {
                             [fromVC performAnimationForTransitionType:kLoginNavigationAnimationTypePoped];
                             [toVC performAnimationForTransitionType:kLoginNavigationAnimationTypeNewVCRemoved];
                         }
                     } completion:^(BOOL finished) {
                         if (self.isPush) {
                             [fromVC didFinishAnimationForTransitionType:kLoginNavigationAnimationTypeNewVCOnTop];
                             [toVC didFinishAnimationForTransitionType:kLoginNavigationAnimationTypePushed];
                         } else {
                             [fromVC didFinishAnimationForTransitionType:kLoginNavigationAnimationTypePoped];
                             [toVC didFinishAnimationForTransitionType:kLoginNavigationAnimationTypeNewVCRemoved];
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
