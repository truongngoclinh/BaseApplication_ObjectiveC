//
//  BMulticastDelegate.h
//  Cyberpay
//
//  Created by Andrew Eng on 6/3/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "GCDMulticastDelegate.h"
#import "GCDMulticastDelegate+Synchronized.h"

@interface BMulticastDelegate : GCDMulticastDelegate

- (void)addDelegateMainQueue:(id)delegate;

@end
