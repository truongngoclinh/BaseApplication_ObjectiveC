//
//  BSolidButton.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BSolidButton.h"

@implementation BSolidButton

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, [self scaleIfNeeded:BThemeButtonHeightDefault]);
}

- (instancetype)initWithStyle:(BSolidButtonStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _shouldScale = YES;
        _style = style;
        [self applyTheme];
    }
    return self;
}

- (instancetype)initWithStyle:(BSolidButtonStyle)style shouldScale:(BOOL)shouldScale
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
    self.titleLabel.font = [BTheme fontOfSize:[self scaleIfNeeded:16]];
    [self themeButtonForControlStatesWithStyle:self.style];
    [self themeButtonBorderWithStyle:self.style];
}

- (void)themeButtonForControlStatesWithStyle:(BSolidButtonStyle)style
{
    UIColor *titleColor = nil;
    UIColor *backgroundColor = nil;
    
    UIColor *highlightedTitleColor = nil;
    UIColor *highlightedBackgroundColor = nil;
    
    UIColor *disabledTitleColor = nil;
    UIColor *disabledBackgroundColor = nil;
    
    switch (style) {
        case BSolidButtonStyleNone:
            titleColor = [BTheme textColorMain];
            highlightedTitleColor = [[BTheme textColorMain] colorWithAlphaComponent:0.8];
            break;
        case BSolidButtonStyleMain:
            
            titleColor = [UIColor whiteColor];
            backgroundColor = [BTheme colorMain];
            
            highlightedTitleColor = [UIColor whiteColor];
            highlightedBackgroundColor = [BTheme colorMainSelected];
            
            disabledTitleColor = [UIColor whiteColor];
            disabledBackgroundColor = [BTheme colorMainDisabled];
            
            break;
            
        case BSolidButtonStyleLight:
            
            titleColor = [BTheme textColorMain];
            backgroundColor = [UIColor whiteColor];
            
            highlightedTitleColor = [[BTheme textColorMain] colorWithAlphaComponent:0.5];
            highlightedBackgroundColor = [UIColor whiteColor];
            
            disabledTitleColor = [[BTheme textColorMain] colorWithAlphaComponent:0.5];
            disabledBackgroundColor = [UIColor whiteColor];
            
            break;
            
        case BSolidButtonStyleLightBlackWhite:
            
            titleColor = [BTheme textColor];
            backgroundColor = [UIColor whiteColor];
            
            highlightedTitleColor = [BTheme textColorLighter];
            highlightedBackgroundColor = [UIColor whiteColor];
            
            disabledTitleColor = [BTheme textColorLighter];
            disabledBackgroundColor = [UIColor whiteColor];
            
            break;
            
        default:
            NSParameterAssert(NO);
            break;
    }
    
    NSParameterAssert(titleColor);
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    if (backgroundColor) {
        [self setBackgroundImage:[BTheme imageForColor:backgroundColor] forState:UIControlStateNormal];
    }
    
    if (highlightedTitleColor) {
        [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    }
    if (highlightedBackgroundColor) {
        [self setBackgroundImage:[BTheme imageForColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
    }
    
    if (disabledTitleColor) {
        [self setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
    }
    if (disabledBackgroundColor) {
        [self setBackgroundImage:[BTheme imageForColor:disabledBackgroundColor] forState:UIControlStateDisabled];
    }
}

- (void)themeButtonBorderWithStyle:(BSolidButtonStyle)style
{
    UIColor *borderColor = nil;
    CGFloat borderWidth = [self scaleIfNeeded:1.0];
    
    switch (style) {
        case BSolidButtonStyleLight: {
            if (self.enabled && !self.highlighted) {
                borderColor = [BTheme textColorMain];
            } else {
                borderColor = [[BTheme textColorMain] colorWithAlphaComponent:0.5];
            }
            break;
        }
        case BSolidButtonStyleLightBlackWhite: {
            if (self.enabled && !self.highlighted) {
                borderColor = [BTheme dividerColor];
            } else {
                borderColor = [[BTheme dividerColor] colorWithAlphaComponent:0.5];
            }
            break;
            break;
        }
        case BSolidButtonStyleNone:
        case BSolidButtonStyleMain:
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

- (void)setStyle:(BSolidButtonStyle)style
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
        return BX(size);
    } else {
        return size;
    }
}

@end
