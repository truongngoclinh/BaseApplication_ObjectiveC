//
//  UIImageView+CPAdditions.h
//  Cyberpay
//
//  Created by yangzhixing on 28/10/15.
//  Copyright © 2015 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BAdditions)

/**
 *  Flip 90 degrees, set image, then flip 90 degrees more.
 */
- (void)b_setImage:(UIImage *)image shouldAnimateFlip:(BOOL)shouldAnimateFlip;

@end
