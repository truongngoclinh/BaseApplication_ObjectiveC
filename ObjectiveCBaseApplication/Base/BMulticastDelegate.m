//
//  BMulticastDelegate.m
//  Cyberpay
//
//  Created by Andrew Eng on 6/3/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "BMulticastDelegate.h"

@implementation BMulticastDelegate

- (void)addDelegateMainQueue:(id)delegate
{
    [self addDelegate:delegate delegateQueue:dispatch_get_main_queue()];
}

@end
