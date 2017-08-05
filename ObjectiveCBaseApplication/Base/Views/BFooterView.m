//
//  BFooterView.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 23/7/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BFooterView.h"
#import "UIView+BView.h"

@interface BFooterView ()

@property (nonatomic, assign) BOOL shouldScale;
@property (nonatomic, strong) UIView *divider;

@end

@implementation BFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _shouldScale = YES;
        [self configureSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame shouldScale:(BOOL)shouldScale
{
    self = [super initWithFrame:frame];
    if (self) {
        _shouldScale = shouldScale;
        [self configureSubViews];
    }
    return self;
}

// Helper
- (void)configureSubViews
{
    _contentInset = UIEdgeInsetsMake([self scaleIfNeeded:BThemePaddingDefault],
                                     [self scaleIfNeeded:BThemePaddingDefault],
                                     [self scaleIfNeeded:BThemePaddingDefault],
                                     [self scaleIfNeeded:BThemePaddingDefault]);
    
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_contentView];
    
    [self configureContentViewConstraints];
}

- (void)configureContentViewConstraints
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(self.contentInset);
    }];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    if (UIEdgeInsetsEqualToEdgeInsets(_contentInset, contentInset))
        return;
    
    _contentInset = contentInset;
    [self configureContentViewConstraints];
    [self setNeedsLayout];
}

- (void)setShowDivider:(BOOL)showDivider
{
    if (_showDivider == showDivider)
        return;
    
    _showDivider = showDivider;
    if (showDivider) {
        self.divider = [self b_addDividerAtPosition:BViewDividerPositionTop
                                               color:[BTheme dividerColor]
                                           thickness:[self scaleIfNeeded:0.5]];
    } else {
        [self.divider removeFromSuperview];
        self.divider = nil;
    }
}

#pragma mark - Util

- (CGFloat)scaleIfNeeded:(CGFloat)size
{
    if (self.shouldScale) {
        return BX(size);
    } else {
        return size;
    }
}

@end
