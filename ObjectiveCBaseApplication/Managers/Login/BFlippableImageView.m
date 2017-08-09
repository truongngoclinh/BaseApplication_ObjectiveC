//
//  BFlippableImageView.m
//  Cyberpay
//
//  Created by Linh on 27/10/15.
//  Copyright © 2015 smvn. All rights reserved.
//

#import "BFlippableImageView.h"

#import "UIImageView+BAdditions.h"

#import "BAuthBaseViewController.h"

@interface BFlippableImageView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BFlippableImageView

- (instancetype)initWithFrame:(CGRect)frame
         imageBackgroundColor:(UIColor*)imageBackgroundColor
                 cornerRadius:(CGFloat)cornerRadius
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView.backgroundColor = imageBackgroundColor;
        self.imageView.layer.cornerRadius = cornerRadius;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        [self configureConstraints];
    }
    return self;
}

- (void)configureConstraints
{
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setImage:(UIImage *)image animated:(BOOL)animated
{
    [self.imageView b_setImage:image shouldAnimateFlip:animated];
}

@end
