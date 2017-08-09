//
//  BClientStream.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BClientStream.h"

@interface BClientStream () <BClientSessionDelegate>

@property (nonatomic, strong, readonly) BClientSession *clientSession;

@end

@implementation BClientStream

+ (instancetype)sharedInstance
{
    static BClientStream *clientStream;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clientStream = [[BClientStream alloc] init];
    });
    return clientStream;
}

+ (BClientSession *)clientSession
{
    return [[self sharedInstance] clientSession];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _multicastDelegate = (id<BClientEvents>)[[BMulticastDelegate alloc] init];
    }
    return self;
}

- (void)startSession
{
    NSParameterAssert(!_clientSession);
    _clientSession = [[BClientSession alloc] initWithDelegate:self];
    [_clientSession startSession];
    [_multicastDelegate addDelegateMainQueue:_clientSession];
}

#pragma mark - BClientSessionDelegate

- (void)clientSessionDidEnd:(BClientSession *)clientSession
{
    _clientSession = nil;
    [self startSession];
}

@end
