//
//  BTheme.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BTheme.h"
#import "UIColor+BAdditions.h"

const CGFloat BThemeCellHeightDefault = 49;
const CGFloat BThemeSectionGapDefault = 10;
const CGFloat BThemePaddingDefault = 13;
const CGFloat BThemeButtonHeightDefault = 42;
const CGFloat BThemeButtonHeightCompact = 36;

@implementation BTheme

#pragma mark - Colors

+ (UIColor *)navigationBarColor
{
    return [UIColor b_colorWithHex:@"384267"];
}

+ (UIColor *)colorMain
{
    return [UIColor b_colorWithHex:@"488cf1"];
}

+ (UIColor *)colorMainSelected
{
    return [UIColor b_colorWithHex:@"4484e4"];
}

+ (UIColor *)colorMainDisabled
{
    return [UIColor b_colorWithHex:@"2B2E30" alpha:0.1];
}

+ (UIColor *)backgroundColor
{
    return [UIColor b_colorWithHex:@"eff3f9"];
}

+ (UIColor *)backgroundColorLight
{
    return [UIColor whiteColor];
}

+ (UIColor *)backgroundColorHighlighted
{
    return [UIColor b_colorWithHex:@"2b2e30" alpha:0.05];
}

+ (UIColor *)textColor
{
    return [self textColorWithAlpha:0.9];
}

+ (UIColor *)textColorLight
{
    return [self textColorWithAlpha:0.7];
}

+ (UIColor *)textColorLighter
{
    return [self textColorWithAlpha:0.5];
}

+ (UIColor *)textColorLightest
{
    return [self textColorWithAlpha:0.3];
}


+ (UIColor *)textColorMain
{
    return [UIColor b_colorWithHex:@"488CF1"];
}

+ (UIColor *)textColorWarm
{
    return [UIColor b_colorWithHex:@"ff9f21"];
}

+ (UIColor *)textColorSuccess
{
    return [UIColor b_colorWithHex:@"27cb7a"];
}

+ (UIColor *)textColorError
{
    return [UIColor b_colorWithHex:@"ff5b18"];
}

+ (UIColor *)textColorWithAlpha:(CGFloat)alpha
{
    return [UIColor b_colorWithHex:@"2b2e30" alpha:alpha];
}


+ (UIColor *)dividerColor
{
    return [UIColor b_colorWithHex:@"DBE1EA"];
}

+ (UIColor *)dividerColorLight
{
    return [[UIColor whiteColor] colorWithAlphaComponent:0.2];
}

+ (UIColor *)successColor
{
    return [UIColor b_colorWithHex:@"27cb7a"];
}

+ (UIColor *)errorColor
{
    return [UIColor b_colorWithHex:@"ff5b18"];
}

+ (UIColor *)footerColor
{
    return [UIColor b_colorWithHex:@"eff3f9"];
}

#pragma mark - Font

+ (UIFont *)fontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)mediumFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)boldFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+ (UIFont *)lightFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

#pragma mark - Utility

+ (UIImage *)imageForColor:(UIColor *)color
{
    return [self imageForColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageForColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
