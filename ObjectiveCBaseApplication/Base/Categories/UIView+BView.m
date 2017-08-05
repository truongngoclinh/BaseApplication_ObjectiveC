//
//  UIView+BView.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "UIView+BView.h"

@implementation UIView (BView)

- (UIView *)b_addDividerAtPosition:(BViewDividerPosition)position color:(UIColor *)color thickness:(CGFloat)thickness
{
    return [self b_addDividerAtPosition:position color:color thickness:thickness inset:UIEdgeInsetsZero];
}

- (UIView *)b_addDividerAtPosition:(BViewDividerPosition)position color:(UIColor *)color thickness:(CGFloat)thickness inset:(UIEdgeInsets)inset
{
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectZero];
    dividerView.backgroundColor = color;
    [self addSubview:dividerView];
    
    [dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        switch (position) {
            case BViewDividerPositionTop:
                make.top.equalTo(self.mas_top).offset(inset.top);
                make.leading.equalTo(self.mas_leading).offset(inset.left);
                make.trailing.equalTo(self.mas_trailing).offset(-inset.right);
                make.height.mas_equalTo(thickness);
                break;
            case BViewDividerPositionLeft:
                make.top.equalTo(self.mas_top).offset(inset.top);
                make.leading.equalTo(self.mas_leading).offset(inset.left);
                make.bottom.equalTo(self.mas_bottom).offset(-inset.bottom);
                make.width.mas_equalTo(thickness);
                break;
            case BViewDividerPositionBottm:
                make.leading.equalTo(self.mas_leading).offset(inset.left);
                make.trailing.equalTo(self.mas_trailing).offset(-inset.right);
                make.bottom.equalTo(self.mas_bottom).offset(-inset.bottom);
                make.height.mas_equalTo(thickness);
                break;
            case BViewDividerPositionRight:
                make.top.equalTo(self.mas_top).offset(inset.top);
                make.trailing.equalTo(self.mas_trailing).offset(-inset.right);
                make.bottom.equalTo(self.mas_bottom).offset(-inset.bottom);
                make.width.mas_equalTo(thickness);
                break;
            default:
                NSAssert(NO, @"Not Supported");
                break;
        }
    }];
    return dividerView;
}

- (void)b_circledWithBackgroundColor:(UIColor *)bgColor
{
    CGFloat cornerRadius = MIN(CGRectGetHeight(self.frame), CGRectGetWidth(self.frame)) / 2;
    
    self.backgroundColor = bgColor;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)b_normalizeCircledViewWithBackgroundColor:(UIColor *)bgColor
{
    self.backgroundColor = bgColor;
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = NO;
}

@end
