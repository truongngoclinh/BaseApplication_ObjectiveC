//
//  BHeaderTitleIconView.m
//  ObjectiveCBaseApplication
//
//  Created by LABS-LEES-MAC on 22/7/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BHeaderTitleIconView.h"

static CGFloat const kIconBackgroundOuterViewSize = 46;
static CGFloat const kIconBackgroundInnerViewSize = 42;

@interface BHeaderTitleIconView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UIView *iconBackgroundOuterView;
@property (nonatomic, strong) UIView *iconBackgroundInnerView;

@end

@implementation BHeaderTitleIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        
        _iconBackgroundOuterView = [[UIView alloc] initWithFrame:CGRectZero];
        _iconBackgroundOuterView.layer.cornerRadius = BX(kIconBackgroundOuterViewSize)/2;
        _iconBackgroundOuterView.backgroundColor = [UIColor whiteColor];
        _iconBackgroundOuterView.clipsToBounds = YES;
        [self addSubview:_iconBackgroundOuterView];
        
        _iconBackgroundInnerView = [[UIView alloc] initWithFrame:CGRectZero];
        _iconBackgroundInnerView.layer.cornerRadius = BX(kIconBackgroundInnerViewSize)/2;
        _iconBackgroundInnerView.backgroundColor = [UIColor b_colorWithHex:@"FCFBF9"];
        _iconBackgroundInnerView.clipsToBounds = YES;
        [_iconBackgroundOuterView addSubview:_iconBackgroundInnerView];
       
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_iconBackgroundOuterView addSubview:_iconView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [BTheme mediumFontOfSize:BX(15)];
        _titleLabel.textColor = [BTheme textColor];
        [self addSubview:_titleLabel];

        [self configureConstraints];
    }

    return self;
}

- (void)configureConstraints
{
    [self.iconBackgroundOuterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(BXSize(CGSizeMake(kIconBackgroundOuterViewSize, kIconBackgroundOuterViewSize)));
        make.leading.equalTo(self.mas_leading);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.iconBackgroundInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconBackgroundOuterView.mas_centerX);
        make.centerY.equalTo(self.iconBackgroundOuterView.mas_centerY);
        make.size.mas_equalTo(BXSize(CGSizeMake(kIconBackgroundInnerViewSize, kIconBackgroundInnerViewSize)));
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconBackgroundOuterView.mas_centerX);
        make.centerY.equalTo(self.iconBackgroundOuterView.mas_centerY);
        make.size.mas_equalTo(BXSize(CGSizeMake(kIconBackgroundInnerViewSize * 0.7, kIconBackgroundInnerViewSize * 0.7)));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(BX(14));
        make.trailing.equalTo(self.mas_trailing);
        make.centerY.equalTo(self.iconView.mas_centerY).offset(BX(4));
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.iconView.image = image;
    [self configureConstraints];
    [self setNeedsLayout];
}

@end
