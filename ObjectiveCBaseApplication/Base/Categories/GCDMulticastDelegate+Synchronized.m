//
//  GCDMulticastDelegate+Synchronized.m
//  Garena
//
//  Created by Lee Sing Jie on 7/8/14.
//  Copyright (c) 2014 Lee Sing Jie. All rights reserved.
//

#import "GCDMulticastDelegate+Synchronized.h"

// http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

@implementation GCDMulticastDelegate (Synchronized)

- (void)syncMulticast:(SEL)selector object:(id)object
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
