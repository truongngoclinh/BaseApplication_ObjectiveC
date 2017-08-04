//
//  NSError+BError.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+BError.h"

@implementation NSError (BError)

+ (NSError *)b_errorWithDomain:(NSString *)domain code:(NSInteger)code
{
    return [self b_errorWithDomain:domain code:code message:nil];
}

+ (NSError *)b_errorWithDomain:(NSString *)domain
                           code:(NSInteger)code
                        message:(NSString *)message
{
    return [self b_errorWithDomain:domain code:code message:message userInfo:nil];
}

+ (NSError *)b_errorWithDomain:(NSString *)domain
                           code:(NSInteger)code
                        message:(NSString *)message
                       userInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *mutableUserInfo = [NSMutableDictionary dictionary];
    
    if (message.length) {
        mutableUserInfo[NSLocalizedDescriptionKey] = message;
    }
    if (userInfo) {
        [mutableUserInfo addEntriesFromDictionary:userInfo];
    }
    
    if (!mutableUserInfo.count) {
        mutableUserInfo = nil;
    }
    
    return [NSError errorWithDomain:domain code:code userInfo:[mutableUserInfo copy]];
}

- (NSString *)b_errorMessage
{
    return self.localizedDescription;
}

@end

@implementation NSError (BNetwork)

- (BOOL)b_isNetworkError
{
    return [self.domain isEqualToString:BNetworkErrorDomain];
}

- (BOOL)b_isResponseError
{
    return [self.domain isEqualToString:BResponseErrorDomain];
}

@end

@implementation NSError (BMantle)

- (BOOL)b_isResponseParsingError
{
    return [self.domain isEqualToString:BTransformerErrorHandlingErrorDomain];
}

- (BOOL)b_isResponseValidatingParsedResultError
{
    return [self.domain isEqualToString:BModelErrorDomain];
}

@end