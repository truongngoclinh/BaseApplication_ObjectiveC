//
//  BSuccessIconHUD.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BSuccessIconHUD.h"

@interface BSuccessIconHUD ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BSuccessIconHUD

- (instancetype)initWithFrame:(CGRect)frame rotatedClockwise:(CGFloat)rotatedClockwise
{
    self = [super initWithFrame:frame];
    if (self) {
        self.HUDBackgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_icon_done"]];
        _imageView.transform = CGAffineTransformMakeRotation(rotatedClockwise);
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)configureConstraints
{
    [super configureConstraints];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
