//
//  BClientStream.h
//  Cyberpay
//
//  Created by Andrew Eng on 18/2/15.
//  Copyright (c) 2015 Garena. All rights reserved.
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
