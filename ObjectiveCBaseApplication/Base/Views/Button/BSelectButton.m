//
//  BSelectButton.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BSelectButton.h"

@interface BSelectButton ()

@property (nonatomic, strong) UIView *roundedRectView;

@end

@implementation BSelectButton

+ (UIFont *)font
{
    return [BTheme lightFontOfSize:BX(15)];
}

+ (UIFont *)selectedFont
{
    return [BTheme mediumFontOfSize:BX(15)];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, BX(BThemeButtonHeightDefault));
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
        self.roundedRectView.layer.borderColor = [BTheme colorMain].CGColor;
        self.roundedRectView.layer.borderWidth = 2.0;
        self.titleLabel.font = [BSelectButton selectedFont];
    } else {
        self.roundedRectView.layer.borderColor = [UIColor b_colorWithHex:@"CED4D8"].CGColor;
        self.roundedRectView.layer.borderWidth = 1.0;
        self.titleLabel.font = [BSelectButton font];
    }
    
    if (self.highlighted) {
        self.roundedRectView.backgroundColor = [BTheme backgroundColorHighlighted];
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
