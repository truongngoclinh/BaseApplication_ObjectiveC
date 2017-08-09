//
//  GGLog.m
//  beetalk-ios-sdk
//
//  Created by Lee Sing Jie on 9/4/14.
//  Copyright (c) 2014 Lee Sing Jie. All rights reserved.
//

#import "BTRemoteLog.h"

#import <sys/utsname.h>

#import "BTSocket.h"

@interface BTRemoteLog () <BTSocketDelegate>

@property (nonatomic, strong) BTSocket *socket;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, assign) NSUInteger sessionCount;

@end

@implementation BTRemoteLog

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (id)init
{
    self = [super init];

    if (self) {
        self.socket = [[BTSocket alloc] initWithDelegate:self];
        [self.socket connectToHost:@"logs.papertrailapp.com:52173" error:nil];

        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setSuspended:YES];
        self.operationQueue.maxConcurrentOperationCount = 1;

        self.uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid-gglog"];

        if (self.uuid == nil) {
            NSUUID  *UUID = [NSUUID UUID];
            self.uuid = [UUID UUIDString];
            [[NSUserDefaults standardUserDefaults] setObject:self.uuid forKey:@"uuid-gglog"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        self.sessionCount = arc4random_uniform(1000);
    }

    return self;
}

+ (void)log:(NSString *)format, ...
{
	va_list args;
	va_start(args, format);

    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];

    [[self sharedInstance] addLogMessage:message];

	va_end(args);
}

NSString*
machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (void)addLogMessage:(NSString *)message
{
    static NSDateFormatter *formatter;

    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:enUSPOSIXLocale];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    }

    static NSString *identifier;

    if (identifier == nil) {
        identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    }

    static NSString *machine;

    if (machine == nil) {
        machine = machineName();
    }

    static NSString *version;

    if (version == nil) {
        NSString *shortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        version = shortVersion;
    }

    NSString *iso8601String = [formatter stringFromDate:[NSDate date]];

    //RFC 5424 (newer)
    //http://help.papertrailapp.com/kb/configuration/configuring-remote-syslog-from-embedded-or-proprietary-systems#rfc-5424-newer-
    NSString *formatMessage = [NSString stringWithFormat:@"<22>1 %@ %@ %@ - - - [%@] <%@-%u> %@", iso8601String, machine, identifier, version, [self.uuid componentsSeparatedByString:@"-"][0], (unsigned int)self.sessionCount, message];

    NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];

    [blockOperation addExecutionBlock:^{
        [self sendMessage:formatMessage];
    }];

    [self.operationQueue addOperation:blockOperation];
}

- (void)sendMessage:(NSString *)message
{
    NSData *data = [[message stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.operationQueue.isSuspended) {
            [self.socket send:data error:nil];
        }
    });
}

#pragma mark - BTSocket

- (void)socketDidConnect:(BTSocket *)socket
{
    [self.operationQueue setSuspended:NO];
}

- (void)socketDidDisconnect:(BTSocket *)socket withError:(NSError *)error
{
    [self.operationQueue setSuspended:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random_uniform(10) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.socket connectToHost:@"logs.papertrailapp.com:52173" error:nil];
    });

}

- (void)socket:(BTSocket *)socket didReceiveData:(NSData *)data
{

}

@end
