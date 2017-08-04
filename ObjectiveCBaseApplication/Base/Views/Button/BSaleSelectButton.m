//
//  BSaleSelectButton.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BSaleSelectButton.h"

#import "BSaleSelectButtonItem.h"

@implementation BSaleSelectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, BX(5), 0, BX(5));
    }
    return self;
}

- (void)setItem:(BSaleSelectButtonItem *)item
{
    _item = item;

    [self setTitle:item.title forState:UIControlStateNormal];

    [self setTitle:item.selectedTitle forState:UIControlStateSelected];
    [self setTitle:item.selectedTitle forState:UIControlStateHighlighted];

    [self setAttributedTitle:item.attributedTitle forState:UIControlStateNormal];

    [self setAttributedTitle:item.selectedAttributedTitle forState:UIControlStateSelected];
    [self setAttributedTitle:item.selectedAttributedTitle forState:UIControlStateHighlighted];

    [self setNeedsLayout];
}

@end
