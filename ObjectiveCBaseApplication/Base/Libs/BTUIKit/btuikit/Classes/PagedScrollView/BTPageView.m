//
//  BTPageView.m
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTPageView.h"

@implementation BTPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (BOOL)shouldCancelTouchesInViewWhenScroll:(UIView *)view
{
    return view == self;
}

- (void)viewDidShow
{

}

- (void)viewDidHide
{

}

- (void)willBeReused
{
    
}

- (void)willBeRecycled
{
    
}

@end
