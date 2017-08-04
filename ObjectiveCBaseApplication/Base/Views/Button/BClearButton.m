//
//  BClearButton.m
//  Cyberpay
//
//  Created by Andrew Eng on 27/4/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "BClearButton.h"

@interface BClearButton ()

@property (strong, nonatomic) UIColor *color;

@end

@implementation BClearButton

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      size.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
}

- (instancetype)initWithColor:(UIColor *)color
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        _color = color;
        
        self.clipsToBounds = YES;
        self.exclusiveTouch = YES;
        self.layer.cornerRadius = BX(2);
        self.layer.borderWidth = BX(1);
        self.layer.borderColor = color.CGColor;
        self.titleEdgeInsets = UIEdgeInsetsMake(BX(4), BX(9), BX(4), BX(9));
        
        [self setTitleColor:self.color
                   forState:UIControlStateNormal];
        [self setTitleColor:[color colorWithAlphaComponent:color.b_alpha * 0.5]
                   forState:UIControlStateDisabled];
        
        [self setBackgroundImage:[BTheme imageForColor:[UIColor clearColor]]
                        forState:UIControlStateNormal];
        [self setBackgroundImage:[BTheme imageForColor:[color colorWithAlphaComponent:color.b_alpha * 0.3]]
                        forState:UIControlStateHighlighted];
        [self setBackgroundImage:[BTheme imageForColor:[color colorWithAlphaComponent:color.b_alpha * 0.15]]
                        forState:UIControlStateDisabled];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    self.layer.borderWidth = enabled ? BX(1) : 0;
}

@end
