//
//  BSwitch.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 23/7/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BSwitch.h"

@implementation BSwitch

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.onTintColor = [BTheme successColor];
    }
    return self;
}

@end
