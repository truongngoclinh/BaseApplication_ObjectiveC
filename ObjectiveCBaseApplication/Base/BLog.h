//
//  BLog.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

// Custom Log Flags and Levels

static const DDLogFlag BLogFlagError          = 1 << 0;
static const DDLogFlag BLogFlagWarning        = 1 << 1;
static const DDLogFlag BLogFlagInfo           = 1 << 2;
static const DDLogFlag BLogFlagDebug          = 1 << 3;
static const DDLogFlag BLogFlagVerbose        = 1 << 4;

static const DDLogFlag BLogFlagNetwork        = 1 << 5;
static const DDLogFlag BLogFlagVCLifeCycle    = 1 << 6;
static const DDLogFlag BLogFlagTB            = 1 << 7;
static const DDLogFlag BLogFlagPrinter        = 1 << 8;

static const DDLogLevel BLogLevelOff               = (DDLogLevel)  0;
static const DDLogLevel BLogLevelError             = (DDLogLevel)  (BLogFlagError);
static const DDLogLevel BLogLevelWarning           = (DDLogLevel)  (BLogLevelError   | BLogFlagWarning);
static const DDLogLevel BLogLevelInfo              = (DDLogLevel)  (BLogLevelWarning | BLogFlagInfo);
static const DDLogLevel BLogLevelDebug             = (DDLogLevel)  (BLogLevelInfo    | BLogFlagDebug);
static const DDLogLevel BLogLevelVerbose           = (DDLogLevel)  (BLogLevelDebug   | BLogFlagVerbose);
static const DDLogLevel BLogLevelInternalRelease   = (DDLogLevel)  (BLogFlagError | BLogFlagWarning | BLogFlagInfo | BLogFlagTB | BLogFlagVCLifeCycle);
static const DDLogLevel BLogLevelAll               = (DDLogLevel)  NSUIntegerMax;

// Convenient Functions

#define B_LOG_OBJC_MAYBE(  async, lvl, flg, ctx, tag, frmt, ...) \
LOG_MAYBE(          async, lvl, flg, ctx, tag, __PRETTY_FUNCTION__,   frmt, ##__VA_ARGS__)

#define B_LOG_C_MAYBE(     async, lvl, flg, ctx, tag, frmt, ...) \
LOG_MAYBE(          async, lvl, flg, ctx, tag, __FUNCTION__,          frmt, ##__VA_ARGS__)

#define B_LogC_Error(frmt, ...)   B_LOG_C_MAYBE(NO,   LOG_LEVEL_DEF, BLogFlagError,   0, nil, frmt, ##__VA_ARGS__)

// Custom Log Functions                               ( async, lvl,         flg,                ctx, tag, frmt, ...)

#define DDLogNetwork(frmt, ...)         B_LOG_OBJC_MAYBE( NO, ddLogLevel,  BLogFlagNetwork,     0, nil, frmt, ##__VA_ARGS__)
#define DDLogCNetwork(frmt, ...)        B_LOG_C_MAYBE(    NO, ddLogLevel,  BLogFlagNetwork,     0, nil, frmt, ##__VA_ARGS__)
#define DDLogVCLifeCycle(frmt, ...)     B_LOG_OBJC_MAYBE( NO, ddLogLevel,  BLogFlagVCLifeCycle, 0, nil, frmt, ##__VA_ARGS__)
#define DDLogTB(frmt, ...)             B_LOG_OBJC_MAYBE( NO, ddLogLevel,  BLogFlagTB,         0, nil, frmt, ##__VA_ARGS__)
#define DDLogCTB(frmt, ...)            B_LOG_C_MAYBE(    NO, ddLogLevel,  BLogFlagTB,         0, nil, frmt, ##__VA_ARGS__)
#define DDLogPrinter(frmt, ...)         B_LOG_C_MAYBE(    NO, ddLogLevel,  BLogFlagPrinter,     0, nil, frmt, ##__VA_ARGS__)

// Log Levels in environments

#if defined DEBUG
#define BLogLevel(debug_level)         static DDLogLevel ddLogLevel = (DDLogLevel)(debug_level);
#elif defined INTRELEASE
#define BLogLevel(debug_level)         static DDLogLevel ddLogLevel = (DDLogLevel)(BLogLevelInternalRelease);
#else
#define BLogLevel(debug_level)         static DDLogLevel ddLogLevel = (DDLogLevel)(BLogLevelOff);
#endif

@interface BLog : NSObject

@end
