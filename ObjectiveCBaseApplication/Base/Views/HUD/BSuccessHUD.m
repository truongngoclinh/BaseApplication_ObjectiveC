//
//  BSuccessHUD.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BSuccessHUD.h"
#import "UIView+BAutoLayout.h"

const NSTimeInterval BSuccessHUDDefaultInterval = 1.5;

@interface BSuccessHUD ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation BSuccessHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stateIcon_success"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [BTheme lightFontOfSize:16];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)configureConstraints
{
    [super configureConstraints];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(36);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.imageView b_setHorizontalCompressionResistanceAndHuggingPriorityHigher];
    [self.imageView b_setVerticalCompressionResistanceAndHuggingPriorityHigher];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(21);
        make.leading.equalTo(self.imageView.mas_trailing).offset(BThemePaddingDefault);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-36);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-21);
        make.width.mas_greaterThanOrEqualTo(105);
    }];
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
}

@end
