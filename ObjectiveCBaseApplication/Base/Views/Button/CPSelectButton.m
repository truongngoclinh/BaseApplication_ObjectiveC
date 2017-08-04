//
//  CPSelectButton.m
//  Cyberpay
//
//  Created by Andrew Eng on 24/7/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "CPSelectButton.h"

@interface CPSelectButton ()

@property (nonatomic, strong) UIView *roundedRectView;

@end

@implementation CPSelectButton

+ (UIFont *)font
{
    return [CPTheme lightFontOfSize:CPX(15)];
}

+ (UIFont *)selectedFont
{
    return [CPTheme mediumFontOfSize:CPX(15)];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, CPX(CPThemeButtonHeightDefault));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;

        _roundedRectView = [[UIView alloc] initWithFrame:CGRectZero];
        _roundedRectView.layer.cornerRadius = 2.0;
        _roundedRectView.userInteractionEnabled = NO;
        [self addSubview:_roundedRectView];
        
        [self selectButtonConfigureConstraints];
        
        [self selectButtonRefresh];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self selectButtonRefresh];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self selectButtonRefresh];
}

- (void)selectButtonRefresh
{
    if (self.selected) {
        self.roundedRectView.layer.borderColor = [CPTheme colorMain].CGColor;
        self.roundedRectView.layer.borderWidth = 2.0;
        self.titleLabel.font = [CPSelectButton selectedFont];
    } else {
        self.roundedRectView.layer.borderColor = [UIColor cp_colorWithHex:@"CED4D8"].CGColor;
        self.roundedRectView.layer.borderWidth = 1.0;
        self.titleLabel.font = [CPSelectButton font];
    }
    
    if (self.highlighted) {
        self.roundedRectView.backgroundColor = [CPTheme backgroundColorHighlighted];
    } else {
        self.roundedRectView.backgroundColor = [UIColor clearColor];
    }
}

- (void)selectButtonConfigureConstraints
{
    [self.roundedRectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Accessors

- (void)setHideTick:(BOOL)hideTick
{
    _hideTick = hideTick;
    [self selectButtonRefresh];
}

@end
