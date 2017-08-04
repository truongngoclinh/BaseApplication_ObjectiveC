//
//  NSError+BServerError.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+BServerError.h"

NSString *const BServerErrorDomain = @"com.smvn.server.error";
NSString *const BServerResponseKey = @"BServerResponseKey";
NSString *const BServerProviderSystemErrorCodeKey = @"resp_code";

@implementation NSError (BServerError)

- (BOOL)b_isServerError
{
    return [self.domain isEqual:BServerErrorDomain];
}

- (BOOL)b_isServerErrorWithCode:(BServerErrorCode)code
{
    return [self b_isServerError] && self.code == code;
}

@end
