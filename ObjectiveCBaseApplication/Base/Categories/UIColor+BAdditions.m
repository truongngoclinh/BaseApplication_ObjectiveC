//
//  UIColor+BAdditions.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "UIColor+BAdditions.h"
#import "UIColor+SAMAdditions.h"

@implementation UIColor (BAdditions)

+ (UIColor *)b_colorWithHex:(NSString *)hex
{
    return [UIColor sam_colorWithHex:hex];
}

+ (UIColor *)b_colorWithHex:(NSString *)hex alpha:(CGFloat)alpha
{
    int alphaHex = alpha*255;
    hex = [NSString stringWithFormat:@"%@%2x", hex, alphaHex];
    return [self b_colorWithHex:hex];
}

- (CGFloat)b_alpha
{
    return [self sam_alpha];
}

@end
