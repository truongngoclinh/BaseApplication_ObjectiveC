//
//  CPNotificationBanner.m
//  Cyberpay
//
//  Created by Andrew Eng on 19/3/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "CPNotificationBanner.h"

#import "CPPaddingLabel.h"

#import "UIView+CPView.h"

#import "UIView+CPAutolayout.h"

@interface CPNotificationBanner ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CPPaddingLabel *buttonLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation CPNotificationBanner

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame buttonTitle:nil];
}

- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundImage:[CPTheme imageForColor:[UIColor cp_colorWithHex:@"fff7da"]]
                        forState:UIControlStateNormal];
        [self setBackgroundImage:[CPTheme imageForColor:[UIColor cp_colorWithHex:@"f8edc3"]]
                        forState:UIControlStateHighlighted];
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = [CPTheme lightFontOfSize:16];
        _label.textColor = [UIColor cp_colorWithHex:@"7b6026"];
        _label.adjustsFontSizeToFitWidth = YES;
        _label.numberOfLines = 2;
        _label.minimumScaleFactor = 0.5;
        [self addSubview:_label];
        
        _buttonLabel = [[CPPaddingLabel alloc] initWithFrame:CGRectZero];
        _buttonLabel.text = buttonTitle;
        _buttonLabel.font = [CPTheme lightFontOfSize:14];
        _buttonLabel.textColor = [CPTheme textColor];
        _buttonLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_buttonLabel];

        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"element_tips_icon_arrow_right"]];
        [self addSubview:_iconImageView];
        
        [self cp_addDividerAtPosition:CPViewDividerPositionBottm
                                color:[UIColor cp_colorWithHex:@"e8dbb6"]
                            thickness:0.5];
        
        _isButtonCircled = NO;
        [self updateButtonLabelStyle];
        
        [self configureConstraints];
    }
    return self;
}

- (void)configureConstraints
{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.leading.equalTo(self.mas_leading).offset(CPThemePaddingDefault);
    }];
    
    [self.buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.greaterThanOrEqualTo(self.label.mas_trailing).offset(5);
        make.width.greaterThanOrEqualTo(self.buttonLabel.mas_height);
    }];
    [self.buttonLabel cp_setHorizontalCompressionResistanceAndHuggingPriorityHigherThanDefault:100];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(self.buttonLabel.mas_trailing).offset(8);
        make.trailing.equalTo(self.mas_trailing).offset(-10);
    }];
    [self.iconImageView cp_setHorizontalCompressionResistanceAndHuggingPriorityHigherThanDefault:110];
}

- (void)updateButtonLabelStyle
{
    if (self.isButtonCircled) {
        self.buttonLabel.insets = UIEdgeInsetsMake(3, 3, 3, 3);
        self.buttonLabel.textColor = [UIColor whiteColor];
        self.buttonLabel.font = [CPTheme lightFontOfSize:12];
        [self.buttonLabel cp_circledWithBackgroundColor:[CPTheme textColorError]];
    } else {
        self.buttonLabel.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.buttonLabel.textColor = [CPTheme textColor];
        self.buttonLabel.font = [CPTheme lightFontOfSize:14];
        [self.buttonLabel cp_normalizeCircledViewWithBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark - Accessors

- (void)setBannerTitle:(NSString *)bannerTitle
{
    _bannerTitle = bannerTitle;
    
    self.label.text = bannerTitle;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    
    self.buttonLabel.text = buttonTitle;
}

- (void)setAttributedBannerTitle:(NSAttributedString *)attributedBannerTitle
{
    _attributedBannerTitle = attributedBannerTitle;
    
    self.label.attributedText = attributedBannerTitle;
}

- (void)setIsButtonCircled:(BOOL)isButtonCircled
{
    _isButtonCircled = isButtonCircled;
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateButtonLabelStyle];
}

@end
