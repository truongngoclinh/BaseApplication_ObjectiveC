//
//  BClientSession.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BClientSession.h"
#import "AppDelegate.h"
#import "BTraverseItem.h"
#import "BMulticastDelegate.h"
#import "NSError+BServerError.h"
#import "BDebugDefine.h"
#import "BCountryLogic.h"

BLogLevel(BLogLevelDebug)

@interface BClientSession ()

@end

@implementation BClientSession

- (instancetype)initWithDelegate:(id<BClientSessionDelegate>)delegate
{
    self = [super init];
    if (self) {
        NSParameterAssert(delegate);
        _delegate = delegate;

        [self initializeManagers];
    }
    return self;
}

- (void)startSession
{
    [self launchMainApp];
//    if (self.managerLogin.sessionInfo) {
//        DDLogInfo(@"[%@] Session info exists. Showing main app as root", self.class);
//        
//        [self initializeSessionManagersWithSessionInfo:self.managerLogin.sessionInfo];
//        [self initializeSession];
//        [self launchMainApp];
//    } else {
//        DDLogInfo(@"[%@] No session info. Showing login as root", self.class);
//        [self launchLogin];
//    }
}

- (void)endSession
{
    [self.delegate clientSessionDidEnd:self];
}

#pragma mark - Launch

//- (void)launchLogin
//{
//    DDLogInfo(@"[%@] launchLogin", self.class);
//   
//    NSParameterAssert(!self.managerLogin.sessionInfo);
//    NSParameterAssert(!self.isInMainApp);
//    
//    self.isInMainApp = NO;
//    [self.managerUI showLoginRootViewController];
//}

- (void)launchMainApp
{
//    DDLogInfo(@"[%@] launchMainAppWithSessionInfo:%@", self.class, self.managerLogin.sessionInfo);
    
//    NSParameterAssert(self.managerLogin.sessionInfo);
//    
//    self.isInMainApp = YES;
    [self.managerUI showRootViewController];
}

#pragma mark - Managers
/** These managers are independent of sessionInfo */
- (void)initializeManagers
{
    BUIService *UIService = [BUIService sharedInstance];
    _managerUI = [[BUIManager alloc] initWithUIService:UIService];
}

/** These managers are dependent on sessionInfo */
- (void)initializeSessionManagersWithSessionInfo:(BLoginSessionInfo *)sessionInfo
{
//    NSParameterAssert(sessionInfo);
}

#pragma mark - Accessors

#pragma mark - Register
#pragma mark Login
#pragma mark Language
#pragma mark - Error Handling
#pragma mark - BClientEvents

@end
