//
//  BDividerLabel.m
//  ObjectiveCBaseApplication
//
//  Created by LABS-LEES-MAC on 24/7/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BDividerLabelView.h"

@interface BDividerLabelView ()

@property (nonatomic, assign) BDividerLabelViewStyle style;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *leftDivider;
@property (nonatomic, strong) UIView *rightDivider;

@end

@implementation BDividerLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:BDividerLabelViewStyleViewDivider];
}

- (instancetype)initWithFrame:(CGRect)frame style:(BDividerLabelViewStyle)style
{
    self = [super initWithFrame:frame];

    if (self) {
        
        _style = style;
        
        _leftDivider = [[UIView alloc] initWithFrame:CGRectZero];
        _leftDivider.backgroundColor = [BTheme dividerColor];
        [self addSubview:_leftDivider];

        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [BTheme textColorLighter];
        _label.font = [BTheme fontOfSize:[self fontSize]];
        [self addSubview:_label];

        _rightDivider = [[UIView alloc] initWithFrame:CGRectZero];
        _rightDivider.backgroundColor = [BTheme dividerColor];
        [self addSubview:_rightDivider];

        [self configureConstraints];
    }

    return self;
}

- (void)configureConstraints
{
    [self.leftDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(self.mas_leading).offset([self edgeOffset]);
        make.trailing.equalTo(self.label.mas_leading).offset(-[self labelPadding]);
        make.height.mas_equalTo(0.5);
    }];

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
    }];

    [self.rightDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(self.label.mas_trailing).offset([self labelPadding]);
        make.trailing.equalTo(self.mas_trailing).offset(-[self edgeOffset]);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title
{
    self.label.text = title;
}

- (NSString *)title
{
    return self.label.text;
}

#pragma mark - Style

- (CGFloat)edgeOffset
{
    CGFloat result = 0;
    
    switch (self.style) {
        case BDividerLabelViewStyleViewDivider: {
            result = 0;
            break;
        }
        case BDividerLabelViewStyleTableViewSectionGap: {
            result = 10;
            break;
        }
        default: {
            NSParameterAssert(NO);
            break;
        }
    }
    
    return result;
}

- (CGFloat)labelPadding
{
    CGFloat result = 0;
    
    switch (self.style) {
        case BDividerLabelViewStyleViewDivider: {
            result = 17;
            break;
        }
        case BDividerLabelViewStyleTableViewSectionGap: {
            result = 5;
            break;
        }
        default: {
            NSParameterAssert(NO);
            break;
        }
    }
    
    return result;
}

- (CGFloat)fontSize
{
    CGFloat result = 15;
    
    switch (self.style) {
        case BDividerLabelViewStyleViewDivider: {
            result = 17;
            break;
        }
        case BDividerLabelViewStyleTableViewSectionGap: {
            result = 14;
            break;
        }
        default: {
            NSParameterAssert(NO);
            break;
        }
    }
    
    return result;
}

@end
