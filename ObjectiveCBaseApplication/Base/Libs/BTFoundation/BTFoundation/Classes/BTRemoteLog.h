//
//  GGLog.h
//  beetalk-ios-sdk
//
//  Created by Lee Sing Jie on 9/4/14.
//  Copyright (c) 2014 Lee Sing Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Real-Time logging is done via https://papertrailapp.com/events */

#define BTRLogLine [BTRemoteLog log:@"<%s:%d>", __PRETTY_FUNCTION__, __LINE__];}
#define BTRLog(format, ...) [BTRemoteLog log:@"<%s:%d> %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:format, ##__VA_ARGS__]];

@interface BTRemoteLog : NSObject

+ (void)log:(NSString *)format, ...;

@end
