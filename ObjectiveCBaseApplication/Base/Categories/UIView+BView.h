//
//  UIView+BView.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BViewDividerPosition)
{
    BViewDividerPositionTop   = 0,
    BViewDividerPositionLeft  = 1,
    BViewDividerPositionBottm = 2,
    BViewDividerPositionRight = 3,
};

@interface UIView (BView)

- (UIView *)b_addDividerAtPosition:(BViewDividerPosition)position color:(UIColor *)color thickness:(CGFloat)thickness;
- (UIView *)b_addDividerAtPosition:(BViewDividerPosition)position color:(UIColor *)color thickness:(CGFloat)thickness inset:(UIEdgeInsets)inset;

/** Make the view circled with a particular background color */
- (void)b_circledWithBackgroundColor:(UIColor *)bgColor;

/** Normalize the circled view by remove corner radius */
- (void)b_normalizeCircledViewWithBackgroundColor:(UIColor *)bgColor;

@end
