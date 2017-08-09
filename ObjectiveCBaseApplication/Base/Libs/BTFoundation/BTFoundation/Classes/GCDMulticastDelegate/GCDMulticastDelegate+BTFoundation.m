//
//  GCDMulticastDelegate+BTAdditions.m
//  BTFoundation
//
//  Created by garena on 4/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "GCDMulticastDelegate+BTFoundation.h"
#import <objc/message.h>

@implementation GCDMulticastDelegate (BTFoundation)

- (void)bt_addDelegateMainQueue:(id)delegate
{
    [self addDelegate:delegate delegateQueue:dispatch_get_main_queue()];
}

- (void)bt_syncMulticast:(SEL)selector object:(id)object
{
    GCDMulticastDelegateEnumerator *delegateEnumerator = [self delegateEnumerator];

    id delegate;
    dispatch_queue_t queue;

    while([delegateEnumerator getNextDelegate:&delegate delegateQueue:&queue forSelector:selector]) {
        IMP imp = [delegate methodForSelector:selector];
        void (*func)(id, SEL, id) = (void *)imp;
        func(delegate, selector, object);
    }
}

@end
