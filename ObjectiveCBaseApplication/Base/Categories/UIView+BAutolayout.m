//
//  UIView+BAutolayout.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "UIView+BAutolayout.h"

@implementation UIView (BAutolayout)

- (void)b_setHorizontalCompressionResistanceAndHuggingPriorityHigher
{
    [self b_setHorizontalCompressionResistanceAndHuggingPriorityHigherThanDefault:100];
}

- (void)b_setVerticalCompressionResistanceAndHuggingPriorityHigher
{
    [self b_setVerticalCompressionResistanceAndHuggingPriorityHigherThanDefault:100];
}

- (void)b_setHorizontalCompressionResistanceAndHuggingPriorityHigherThanDefault:(NSInteger)higherThanDefault
{
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow + higherThanDefault
                            forAxis:UILayoutConstraintAxisHorizontal];
    
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + higherThanDefault
                                          forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)b_setVerticalCompressionResistanceAndHuggingPriorityHigherThanDefault:(NSInteger)higherThanDefault
{
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow + higherThanDefault
                            forAxis:UILayoutConstraintAxisVertical];
    
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + higherThanDefault
                                          forAxis:UILayoutConstraintAxisVertical];
}

@end
