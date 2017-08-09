//
//  GCDMulticastDelegate+BTAdditions.h
//  BTFoundation
//
//  Created by garena on 4/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "GCDMulticastDelegate.h"

@interface GCDMulticastDelegate (BTFoundation)

- (void)bt_addDelegateMainQueue:(id)delegate;
- (void)bt_syncMulticast:(SEL)selector object:(id)object;

@end
