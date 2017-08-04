//
//  BArrowButton.m
//  Cyberpay
//
//  Created by yangzhixing on 9/10/15.
//  Copyright © 2015 Garena. All rights reserved.
//

#import "BArrowButton.h"

@interface BArrowButton ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation BArrowButton

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, [self scaleIfNeeded:BThemeCellHeightDefault]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _shouldScale = YES;
        
        [self setBackgroundImage:[BTheme imageForColor:[UIColor whiteColor]]
                        forState:UIControlStateNormal];
        [self setBackgroundImage:[BTheme imageForColor:[BTheme backgroundColorHighlighted]]
                        forState:UIControlStateHighlighted];
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textColor = [BTheme textColor];
        [self addSubview:_label];
        
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"element_list_icon_arrow_right"]];
        [self addSubview:_iconImageView];
        
        [self configureConstraints];
    }
    return self;
}

- (void)configureConstraints
{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(self.mas_leading).offset([self scaleIfNeeded:BThemePaddingDefault]);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.greaterThanOrEqualTo(self.label.mas_trailing).offset([self scaleIfNeeded:2]);
        make.trailing.equalTo(self.mas_trailing).offset([self scaleIfNeeded:-BThemePaddingDefault + 2]);
        BXMasImage(self.iconImageView.image);
    }];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title bold:(BOOL)bold
{
    self.label.text = title;
    
    if (!bold) {
        self.label.font = [BTheme lightFontOfSize:[self scaleIfNeeded:15]];
    } else {
        self.label.font = [BTheme fontOfSize:[self scaleIfNeeded:15]];
    }
}

- (void)setArrowImage:(UIImage *)arrowImage {
    
    self.iconImageView.image = arrowImage;
    
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        BXMasImage(self.iconImageView.image);
    }];
    
    [self setNeedsLayout];
}
- (UIImage *)arrowImage { return self.iconImageView.image; }

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
