//
//  GCDMulticastDelegate+Synchronized.h
//  Garena
//
//  Created by Lee Sing Jie on 7/8/14.
//  Copyright (c) 2014 Lee Sing Jie. All rights reserved.
//

#import "GCDMulticastDelegate.h"

@interface GCDMulticastDelegate (Synchronized)

- (void)syncMulticast:(SEL)selector object:(id)object;

@end
