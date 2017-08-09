//
//  UIScrollView+BFitSize.m
//  Cyberpay
//
//  Created by yangzhixing on 1/9/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "UIScrollView+BFitSize.h"
#import <objc/runtime.h>

static char BScrollViewFitSizePlaceholderViewIdentifier;

@implementation UIScrollView (BFitSize)

- (void)b_fitScrollViewWidth
{
    UIView *b_placeholderView = self.b_placeholderView;
    
    [b_placeholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.width.equalTo(self.mas_width);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
}

- (void)b_fitScrollViewMinimumHeight
{
    UIView *b_placeholderView = self.b_placeholderView;
    [b_placeholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height).offset(-self.contentInset.top);
        make.bottom.lessThanOrEqualTo(self.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).priority(MASLayoutPriorityFittingSizeLevel + 1);
        
        make.leading.equalTo(self.mas_leading);
        make.width.mas_equalTo(0);
    }];
}

- (void)b_fitScrollViewWidthAndMininumHeight
{    
    UIView *b_placeholderView = self.b_placeholderView;
    
    [b_placeholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height).offset(-self.contentInset.top);
        make.bottom.lessThanOrEqualTo(self.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).priority(MASLayoutPriorityFittingSizeLevel + 1);
        
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.width.equalTo(self.mas_width);
    }];
}

#pragma mark - Accessors

- (void)setCp_placeholderView:(UIView *)b_placeholderView
{
    objc_setAssociatedObject(self, &BScrollViewFitSizePlaceholderViewIdentifier, b_placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)b_placeholderView
{
    NSAssert([self isKindOfClass:UIScrollView.class], @"Adding subViews with autolayout in tableViews or collections might cause problems in iOS 7.");
    
    UIView *b_placeholderView = objc_getAssociatedObject(self, &BScrollViewFitSizePlaceholderViewIdentifier);

    if (b_placeholderView == nil) {
        b_placeholderView = [[UIView alloc] initWithFrame:CGRectZero];
        [self insertSubview:b_placeholderView atIndex:0];
        [self setCp_placeholderView:b_placeholderView];
    }
    return b_placeholderView;
}

@end
