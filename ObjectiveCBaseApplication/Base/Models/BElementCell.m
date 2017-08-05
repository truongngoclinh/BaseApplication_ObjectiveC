//
//  BElementCell.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 24/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BElementCell.h"

@implementation BElementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.borderThickness = 0.5;
        self.borderColor = [BTheme dividerColor];
    }
    return self;
}

#pragma mark - Highlight

- (void)updateBackgroundColor
{
    if (self.isHighlighted) {
        self.backgroundView.backgroundColor = [BTheme backgroundColorHighlighted];
    } else {
        self.backgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (self.highlightStyle == BElementCellHighlightStyleNormal) {
        
        [UIView animateWithDuration:0.1 animations:^{
            [self updateBackgroundColor];
        } completion:NULL];
    }
}

- (void)setHighlightStyle:(BElementCellHighlightStyle)highlightStyle
{
    if (_highlightStyle == highlightStyle)
        return;
    
    _highlightStyle = highlightStyle;
    
    if (highlightStyle == BElementCellHighlightStyleNormal) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self updateBackgroundColor];
    } else if (highlightStyle == BElementCellHighlightStyleNone) {
        self.backgroundView = nil;
    } else {
        NSParameterAssert(NO);
        self.backgroundView = nil;
    }
}

@end
