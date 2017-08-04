//
//  BScale.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BScale.h"

@implementation BScale

+ (CGFloat)scaleCGFloat:(CGFloat)x
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat width = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        scale = width/320.0;
    });
    
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    
    return floor(x*scale*deviceScale)/deviceScale;
}

+ (CGSize)scaleCGSize:(CGSize)size
{
    return CGSizeMake([self scaleCGFloat:size.width], [self scaleCGFloat:size.height]);
}

@end
