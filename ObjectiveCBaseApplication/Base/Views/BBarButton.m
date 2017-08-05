//
//  BBarButton.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 18/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BBarButton.h"

@implementation BBarButton

- (void)refresh
{
    UIImage *normalImage = [self imageForState:UIControlStateNormal];
    UIImage *disabledImage = [self imageForState:UIControlStateDisabled];
    UIImage *highlightedImage = [self imageForState:UIControlStateHighlighted];
    
    // If disabled and no disabled image
    if (!self.isEnabled && (normalImage == disabledImage)) {
        self.alpha = 0.5;
    }
    // If highlighted and no highlighted image
    else if (self.highlighted && (normalImage == highlightedImage)) {
        self.alpha = 0.5;
    }
    else {
        self.alpha = 1;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self refresh];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self refresh];
}

@end
