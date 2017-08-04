//
//  CPSolidButton.m
//  Cyberpay
//
//  Created by Andrew Eng on 23/7/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "CPSolidButton.h"

@implementation CPSolidButton

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, [self scaleIfNeeded:CPThemeButtonHeightDefault]);
}

- (instancetype)initWithStyle:(CPSolidButtonStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _shouldScale = YES;
        _style = style;
        [self applyTheme];
    }
    return self;
}

- (instancetype)initWithStyle:(CPSolidButtonStyle)style shouldScale:(BOOL)shouldScale
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _shouldScale = shouldScale;
        _style = style;
        [self applyTheme];
    }
    return self;
}

// Helper
- (void)applyTheme
{
    self.layer.cornerRadius = [self scaleIfNeeded:2];
    self.clipsToBounds = YES;
    self.titleLabel.font = [CPTheme fontOfSize:[self scaleIfNeeded:16]];
    [self themeButtonForControlStatesWithStyle:self.style];
    [self themeButtonBorderWithStyle:self.style];
}

- (void)themeButtonForControlStatesWithStyle:(CPSolidButtonStyle)style
{
    UIColor *titleColor = nil;
    UIColor *backgroundColor = nil;
    
    UIColor *highlightedTitleColor = nil;
    UIColor *highlightedBackgroundColor = nil;
    
    UIColor *disabledTitleColor = nil;
    UIColor *disabledBackgroundColor = nil;
    
    switch (style) {
        case CPSolidButtonStyleNone:
            titleColor = [CPTheme textColorMain];
            highlightedTitleColor = [[CPTheme textColorMain] colorWithAlphaComponent:0.8];
            break;
        case CPSolidButtonStyleMain:
            
            titleColor = [UIColor whiteColor];
            backgroundColor = [CPTheme colorMain];
            
            highlightedTitleColor = [UIColor whiteColor];
            highlightedBackgroundColor = [CPTheme colorMainSelected];
            
            disabledTitleColor = [UIColor whiteColor];
            disabledBackgroundColor = [CPTheme colorMainDisabled];
            
            break;
            
        case CPSolidButtonStyleLight:
            
            titleColor = [CPTheme textColorMain];
            backgroundColor = [UIColor whiteColor];
            
            highlightedTitleColor = [[CPTheme textColorMain] colorWithAlphaComponent:0.5];
            highlightedBackgroundColor = [UIColor whiteColor];
            
            disabledTitleColor = [[CPTheme textColorMain] colorWithAlphaComponent:0.5];
            disabledBackgroundColor = [UIColor whiteColor];
            
            break;
            
        case CPSolidButtonStyleLightBlackWhite:
            
            titleColor = [CPTheme textColor];
            backgroundColor = [UIColor whiteColor];
            
            highlightedTitleColor = [CPTheme textColorLighter];
            highlightedBackgroundColor = [UIColor whiteColor];
            
            disabledTitleColor = [CPTheme textColorLighter];
            disabledBackgroundColor = [UIColor whiteColor];
            
            break;
            
        default:
            NSParameterAssert(NO);
            break;
    }
    
    NSParameterAssert(titleColor);
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    if (backgroundColor) {
        [self setBackgroundImage:[CPTheme imageForColor:backgroundColor] forState:UIControlStateNormal];
    }
    
    if (highlightedTitleColor) {
        [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    }
    if (highlightedBackgroundColor) {
        [self setBackgroundImage:[CPTheme imageForColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
    }
    
    if (disabledTitleColor) {
        [self setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
    }
    if (disabledBackgroundColor) {
        [self setBackgroundImage:[CPTheme imageForColor:disabledBackgroundColor] forState:UIControlStateDisabled];
    }
}

- (void)themeButtonBorderWithStyle:(CPSolidButtonStyle)style
{
    UIColor *borderColor = nil;
    CGFloat borderWidth = [self scaleIfNeeded:1.0];
    
    switch (style) {
        case CPSolidButtonStyleLight: {
            if (self.enabled && !self.highlighted) {
                borderColor = [CPTheme textColorMain];
            } else {
                borderColor = [[CPTheme textColorMain] colorWithAlphaComponent:0.5];
            }
            break;
        }
        case CPSolidButtonStyleLightBlackWhite: {
            if (self.enabled && !self.highlighted) {
                borderColor = [CPTheme dividerColor];
            } else {
                borderColor = [[CPTheme dividerColor] colorWithAlphaComponent:0.5];
            }
            break;
            break;
        }
        case CPSolidButtonStyleNone:
        case CPSolidButtonStyleMain:
        default:
            break;
    }
    
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = borderWidth;
    }
}

#pragma mark - Setters

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self themeButtonBorderWithStyle:self.style];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self themeButtonBorderWithStyle:self.style];
}

- (void)setStyle:(CPSolidButtonStyle)style
{
    _style = style;
    [self applyTheme];
    [self setNeedsLayout];
}

- (void)setShouldScale:(BOOL)shouldScale
{
    _shouldScale = shouldScale;
    [self applyTheme];
    [self setNeedsLayout];
}

#pragma mark - Helpers

- (CGFloat)scaleIfNeeded:(CGFloat)size
{
    if (self.shouldScale) {
        return CPX(size);
    } else {
        return size;
    }
}

@end
