//
//  BClientStream.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BClientSession.h"
#import "BMulticastDelegate.h"
#import "BClientEvents.h"

@interface BClientStream : NSObject

@property (nonatomic, strong, readonly) BMulticastDelegate *multicastDelegate;

+ (instancetype)sharedInstance;
- (void)startSession;
+ (BClientSession *)clientSession;

@end
