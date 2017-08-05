//
//  BTPageViewSample.m
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTPageViewSample.h"

@interface BTPageViewSample ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *reuseButton;
@property (nonatomic, strong) UIButton *recycleButton;

@end

@implementation BTPageViewSample

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];

        self.reuseButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.reuseButton setTitle:@"Pressed" forState:UIControlStateHighlighted];
        [self.reuseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:self.reuseButton];

        self.recycleButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.recycleButton setTitle:@"Pressed" forState:UIControlStateHighlighted];
        [self.recycleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:self.recycleButton];

        self.backgroundColor = [UIColor yellowColor];

        [self updateButtonText];
    }

    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
    [self setNeedsLayout];
}

- (void)updateButtonText
{
    [self.reuseButton setTitle:[NSString stringWithFormat:@"Reused count : %ld", (long)self.reusedCount]
                      forState:UIControlStateNormal];

    [self.recycleButton setTitle:[NSString stringWithFormat:@"Recycled count : %ld", (long)self.recycledCount]
                        forState:UIControlStateNormal];

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.label sizeToFit];
    self.label.frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(self.label.frame))/2, 20,
                                  CGRectGetWidth(self.label.frame), CGRectGetHeight(self.label.frame));

    [self.reuseButton sizeToFit];
    self.reuseButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(self.reuseButton.frame))/2, CGRectGetMaxY(self.label.frame) + 20,
                                        CGRectGetWidth(self.reuseButton.frame), CGRectGetHeight(self.reuseButton.frame));

    [self.recycleButton sizeToFit];
    self.recycleButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(self.recycleButton.frame))/2, CGRectGetMaxY(self.reuseButton.frame) + 20,
                                          CGRectGetWidth(self.recycleButton.frame), CGRectGetHeight(self.recycleButton.frame));
}

- (void)viewDidShow
{

}

- (void)viewDidHide
{

}

- (void)willBeReused
{
    _reusedCount ++;
    [self updateButtonText];
}

- (void)willBeRecycled
{
    _recycledCount ++;
    [self updateButtonText];
}

- (BOOL)shouldCancelTouchesInViewWhenScroll:(UIView *)view
{
    if (view == self.reuseButton || view == self.recycleButton) {
        return YES;
    }

    return [super shouldCancelTouchesInViewWhenScroll:view];
}

@end
