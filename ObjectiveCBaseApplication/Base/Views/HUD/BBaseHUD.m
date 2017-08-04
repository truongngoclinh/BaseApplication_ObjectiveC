
//
//  BBaseHUD.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BBaseHUD.h"

const NSTimeInterval BHUDDurationInfinite = 0;

static const NSTimeInterval kAnimationDuration = 0.2;

@interface BBaseHUD ()

@property (nonatomic, strong) UIView *HUDView;

@end

@implementation BBaseHUD

+ (NSTimeInterval)durationForText:(NSString *)text
{
    NSInteger kLengthPerUnit = 10;
    NSTimeInterval kDurationPerUnit = 0.5;
    NSTimeInterval kMinDuration = 1.5;
    
    NSInteger numberOfUnits = ceil(text.length * 1.0 / kLengthPerUnit);
    NSTimeInterval duration = numberOfUnits * kDurationPerUnit;
    duration = MAX(duration, kMinDuration);
    return duration;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.alpha = 0;
        
        _HUDView = [[UIView alloc] init];
        _HUDView.layer.cornerRadius = 7;
        _HUDView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        [self addSubview:_HUDView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_HUDView addSubview:_contentView];
    }
    return self;
}

- (void)configureConstraints
{
    [self.HUDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.leading.greaterThanOrEqualTo(self.mas_leading).offset(25);
        make.trailing.lessThanOrEqualTo(self.mas_trailing).offset(-25);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.HUDView);
    }];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.HUDView.center = center;
}

- (BOOL)isShowing
{
    return (self.superview != nil);
}

- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration
{
    [self showInView:view duration:duration completion:nil];
}

- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration completion:(BHUDCompletion)completion
{
    [self showInView:view];
    
    if (duration != BHUDDurationInfinite && duration > 0) {
        BWeakify(self, me);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [me hide];
            if (completion) completion();
        });
    }
}

- (void)showInView:(UIView *)view
{
    self.frame = view.bounds;
    [view addSubview:self];

    [self configureConstraints];
    [view setNeedsLayout];
    
    self.HUDView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
        self.HUDView.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)hide
{
    BWeakify(self, me);
    [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
        self.HUDView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [me cleanUp];
    }];
}

- (void)cleanUp
{
    [self removeFromSuperview];
}

#pragma mark - Modifiers

- (UIColor *)HUDBackgroundColor
{
    return _HUDView.backgroundColor;
}

- (void)setHUDBackgroundColor:(UIColor *)HUDBackgroundColor
{
    _HUDView.backgroundColor = HUDBackgroundColor;
}

@end
