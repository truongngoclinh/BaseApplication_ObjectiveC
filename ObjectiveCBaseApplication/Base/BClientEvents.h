//
//  CPClientEvents.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>

@protocol BClientEvents <NSObject>

@optional

- (void)didBecomeActive:(UIApplication *)sender;
- (void)willResignActive:(UIApplication *)sender;
- (void)didEnterBackground:(UIApplication *)sender;
- (void)willEnterForeground:(UIApplication *)sender;
- (void)willTerminate:(UIApplication *)sender;
- (void)didReceiveMemoryWarning:(UIApplication *)sender;

- (void)willEndBackgroundMode:(id)sender;

@end
