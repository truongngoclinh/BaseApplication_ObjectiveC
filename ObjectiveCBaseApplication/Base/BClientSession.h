//
//  BClientSession.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>
#import "BClientEvents.h"
#import "BUIManager.h"
#import "BLoginSessionInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class BClientSession;
@protocol BClientSessionDelegate <NSObject>

- (void)clientSessionDidEnd:(BClientSession *)clientSession;

@end

@interface BClientSession : NSObject <BClientEvents>

@property (nonatomic, weak, readonly) id<BClientSessionDelegate> delegate;

@property (nonatomic, strong, readonly) BUIManager *managerUI;

- (instancetype)initWithDelegate:(id<BClientSessionDelegate>)delegate;

- (void)launchMainApp;
- (void)startSession;
- (void)endSession;

@end

NS_ASSUME_NONNULL_END