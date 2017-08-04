//
//  BLoadingHUD.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BLoadingHUD.h"

const NSTimeInterval BLoadingHUDMaxInterval = 180;

@interface BLoadingHUD ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation BLoadingHUD

/* Included to prevent image removal script from deleting these images.
 @"loading_000", @"loading_001", @"loading_002", @"loading_003", @"loading_004", @"loading_005",
 @"loading_006", @"loading_007", @"loading_008", @"loading_009", @"loading_010", @"loading_011",
 @"loading_012", @"loading_013", @"loading_014", @"loading_015", @"loading_016", @"loading_017",
 @"loading_018", @"loading_019", @"loading_020", @"loading_021", @"loading_022", @"loading_023",
 @"loading_024", @"loading_025", @"loading_026", @"loading_027", @"loading_028", @"loading_029",
 @"loading_030", @"loading_031", @"loading_032", @"loading_033", @"loading_034", @"loading_035",
 @"loading_036", @"loading_037", @"loading_038", @"loading_039", @"loading_040", @"loading_041"
 */
+ (NSArray *)loadingImages
{
    static NSArray *loadingImages;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i <= 41; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%03d", i]]];
        }
        loadingImages = [images copy];
    });
    return loadingImages;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame text:nil];
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_centerLogo"]];
        [self.contentView addSubview:_logoImageView];
        
        NSArray *images = [BLoadingHUD loadingImages];
        
        _imageView = [[UIImageView alloc] initWithImage:[images firstObject]];
        _imageView.animationImages = images;
        _imageView.animationDuration = 1;
        [self.contentView addSubview:_imageView];
        
        if (text) {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _textLabel.text = text;
            _textLabel.font = [BTheme lightFontOfSize:16];
            _textLabel.textColor = [UIColor whiteColor];
            _textLabel.textAlignment = NSTextAlignmentCenter;
            _textLabel.numberOfLines = 0;
            [self.contentView addSubview:_textLabel];
        }
    }
    return self;
}

- (void)configureConstraints
{
    [super configureConstraints];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.mas_equalTo(self.logoImageView.image.size.width/2);
        make.height.mas_equalTo(self.logoImageView.image.size.height/2);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(BX(10));
        make.width.mas_equalTo(self.imageView.image.size.width/2);
        make.height.mas_equalTo(self.imageView.image.size.height/2);
        
        if (!self.textLabel) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
            make.leading.equalTo(self.contentView.mas_leading).offset(12);
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-12);
        } else {
            make.centerX.equalTo(self.contentView.mas_centerX);
        }
    }];
    
    if (self.textLabel) {
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(12);
            make.leading.equalTo(self.contentView.mas_leading).offset(24);
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-24);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
            make.width.mas_greaterThanOrEqualTo(105);
        }];
    }
}

- (void)showInView:(UIView *)view
{
    [super showInView:view];
    [self.imageView startAnimating];
}

- (void)hide
{
    [super hide];
    [self.imageView stopAnimating];
}

@end
