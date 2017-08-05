//
//  BTElementCell.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTElementCell.h"

static UIColor *defaultTitleColor;
static UIFont *defaultTitleFont;
static UIColor *defaultSubTitleColor;
static UIFont *defaultSubTitleFont;
static UIColor *defaultBackgroundColor;
static UIColor *defaultSelectedBackgroundColor;
static UIColor *defaultBorderColor;

@interface BTElementCell ()

@property (nonatomic, strong) CALayer *topBorderLayer;
@property (nonatomic, strong) CALayer *bottomBorderLayer;

@property (nonatomic, strong) UIColor *originalTitleColor;
@property (nonatomic, strong) UIColor *originalSubTitleColor;
@property (nonatomic, strong) UIFont *originalTitleFont;
@property (nonatomic, strong) UIFont *originalSubTitleFont;

@end

@implementation BTElementCell

@synthesize borderColor = _borderColor;

+ (void)themeDefaultTitleColor:(UIColor *)color
{
    defaultTitleColor = color;
}

+ (void)themeDefaultSubTitleColor:(UIColor *)subTitlecolor
{
    defaultSubTitleColor = subTitlecolor;
}

+ (void)themeDefaultTitleFont:(UIFont *)titleFont
{
    defaultTitleFont = titleFont;
}

+ (void)themeDefaultSubTitleFont:(UIFont *)subTitleFont
{
    defaultSubTitleFont = subTitleFont;
}

+ (void)themeDefaultBackgroundColor:(UIColor *)backgroundColor
{
    defaultBackgroundColor = backgroundColor;
}

+ (void)themeDefaultSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    defaultSelectedBackgroundColor = selectedBackgroundColor;
}

+ (void)themeDefaultBorderColor:(UIColor *)borderColor
{
    defaultBorderColor = borderColor;
}

- (void)commonInit
{
    [self styleElements];
}

- (UIColor *)defaultTextLabelColor
{
    if (defaultTitleColor) {
        return defaultTitleColor;
    }

    return self.originalTitleColor;
}

- (UIColor *)defaultDetailTextLabelColor
{
    if (defaultSubTitleColor) {
        return defaultSubTitleColor;
    }
    return self.originalSubTitleColor;
}

- (UIFont *)defaultTextFont
{
    if (defaultTitleFont) {
        return defaultTitleFont;
    }
    return self.originalTitleFont;
}

- (UIFont *)defaultDetailTextFont
{
    if (defaultSubTitleFont) {
        return defaultSubTitleFont;
    }
    return self.originalSubTitleFont;
}

- (void)styleElements
{
    self.textLabel.font = [self defaultTextFont];
    self.textLabel.textColor = [self defaultTextLabelColor];
    self.textLabel.backgroundColor = [UIColor clearColor];

    self.detailTextLabel.font = [self defaultDetailTextFont];
    self.detailTextLabel.textColor = [self defaultDetailTextLabelColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];

    self.contentView.backgroundColor = [UIColor clearColor];

    if (defaultBackgroundColor) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColor = defaultBackgroundColor;
        self.backgroundView = backgroundView;
    }

    if (defaultSelectedBackgroundColor) {
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColor = defaultSelectedBackgroundColor;
        self.selectedBackgroundView = selectedBackgroundView;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];

        self.topBorderLayer = [[CALayer alloc] init];
        self.topBorderLayer.backgroundColor = [self borderColor].CGColor;
        [self.layer addSublayer:self.topBorderLayer];

        self.bottomBorderLayer = [[CALayer alloc] init];
        self.bottomBorderLayer.backgroundColor = [self borderColor].CGColor;
        [self.layer addSublayer:self.bottomBorderLayer];

        self.originalTitleColor = self.textLabel.textColor;
        self.originalTitleFont = self.textLabel.font;
        self.originalSubTitleColor = self.detailTextLabel.textColor;
        self.originalSubTitleFont = self.detailTextLabel.font;
    }
    return self;
}

- (void)setSubTitleColor:(UIColor *)subTitleColor
{
    _subTitleColor = subTitleColor;

    if (subTitleColor) {
        self.detailTextLabel.textColor = subTitleColor;
    } else {
        self.detailTextLabel.textColor = [self defaultDetailTextLabelColor];
    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;

    if (titleColor) {
        self.textLabel.textColor = titleColor;
    } else {
        self.textLabel.textColor = [self defaultTextLabelColor];
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;

    if (titleFont) {
        self.textLabel.font = titleFont;
    } else {
        self.textLabel.font = [self defaultTextFont];
    }
}

- (void)setSubTitleFont:(UIFont *)subTitleFont
{
    _subTitleFont = subTitleFont;

    if (subTitleFont) {
        self.detailTextLabel.font = subTitleFont;
    } else {
        self.detailTextLabel.font = [self defaultDetailTextFont];
    }
}

- (void)setBorderThickness:(CGFloat)borderThickness
{
    _borderThickness = borderThickness;
    [self setNeedsLayout];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.topBorderLayer.backgroundColor = [self borderColor].CGColor;
    self.bottomBorderLayer.backgroundColor = [self borderColor].CGColor;
}

- (UIColor *)borderColor
{
    if (_borderColor) {
        return _borderColor;
    }
    if (defaultBorderColor) {
        return defaultBorderColor;
    }
    return [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
}

- (void)setShowTopBorder:(BOOL)showTopBorder
{
    _showTopBorder = showTopBorder;

    self.topBorderLayer.hidden = !showTopBorder;
}

- (void)setShowBottomBorder:(BOOL)showBottomBorder
{
    _showBottomBorder = showBottomBorder;

    self.bottomBorderLayer.hidden = !showBottomBorder;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self commonInit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Adjust border
    CGFloat borderHeight = (self.borderThickness != 0) ? self.borderThickness : 1.0/[UIScreen mainScreen].scale;
    CGFloat width = CGRectGetWidth(self.bounds);
    self.topBorderLayer.frame = CGRectMake(0,0,width,borderHeight);
    self.bottomBorderLayer.frame = CGRectMake(self.bottomBorderLeftPadding,CGRectGetHeight(self.bounds) - borderHeight,width-self.bottomBorderLeftPadding-self.bottomBorderRightPadding,borderHeight);

    if (self.detailTextLabel.frame.origin.x <= 120)
    {
        // so detailTextLabel will always start after 120
        CGRect frame = self.detailTextLabel.frame;
        frame.size.width -= 120 - frame.origin.x;
        frame.origin.x = 120;
        self.detailTextLabel.frame = frame;
    }
}

@end
