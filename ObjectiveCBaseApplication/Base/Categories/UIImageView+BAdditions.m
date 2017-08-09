//
//  UIImageView+BAdditions.m
//  Cyberpay
//
//  Created by yangzhixing on 28/10/15.
//  Copyright © 2015 Garena. All rights reserved.
//

static CGFloat const kAnimationDuration = 0.4;

#import "UIImageView+BAdditions.h"

@implementation UIImageView (BAdditions)

- (void)b_setImage:(UIImage *)image shouldAnimateFlip:(BOOL)shouldAnimateFlip
{
    if (!shouldAnimateFlip) {
        self.image = image;
    } else {
        [self b_flipUpWithNewImage:image];
    }
}

- (void)b_flipUpWithNewImage:(UIImage *)image
{
    [CATransaction begin]; {
        
        [CATransaction setCompletionBlock:^{
            [self b_flipDownWithNewImage:image];
        }];
        
        CABasicAnimation* foregroundAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        foregroundAnimation.fromValue = @(0);
        foregroundAnimation.toValue = @(M_PI / 2);
        foregroundAnimation.repeatCount = 1;
        foregroundAnimation.duration = kAnimationDuration / 2;
        
        // Prevent it from sneaking back to original position:
        foregroundAnimation.fillMode = kCAFillModeForwards;
        foregroundAnimation.removedOnCompletion = NO;
        
        [self.layer addAnimation:foregroundAnimation forKey:@"rotationAnimation"];
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0 / 500.0;
        self.layer.transform = transform;
        
    } [CATransaction commit];
}

- (void)b_flipDownWithNewImage:(UIImage *)image
{
    self.image = image;
    
    [CATransaction begin]; {
        
        [CATransaction setCompletionBlock:^{
            [self.layer removeAllAnimations];
        }];
        
        CABasicAnimation* foregroundAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        foregroundAnimation.fromValue = @(- M_PI / 2);
        foregroundAnimation.toValue = @(0);
        foregroundAnimation.repeatCount = 1;
        foregroundAnimation.duration = kAnimationDuration / 2;
        
        [self.layer addAnimation:foregroundAnimation forKey:@"rotationAnimation"];
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0 / 500.0;
        self.layer.transform = transform;
        
    } [CATransaction commit];
}

@end
