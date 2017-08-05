//
//  BNavigationBar.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 2/2/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BNavigationBar.h"
#import "UIView+BView.h"

@interface BNavigationBar ()

@property (nonatomic, strong) UIView *dividerView;

@end

@implementation BNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundImage:[BTheme imageForColor:[BTheme navigationBarColor]] forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [[UIImage alloc] init];
        self.translucent = NO;
        
    }
    return self;
}

@end
