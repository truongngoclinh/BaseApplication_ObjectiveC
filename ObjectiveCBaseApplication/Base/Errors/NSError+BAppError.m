//
//  NSError+BAppError.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+BAppError.h"

NSString *const BAppErrorDomain = @"com.garena.cyberpay.app.error";

@implementation NSError (BAppError)

- (BOOL)b_isAppError
{
    return [self.domain isEqualToString:BAppErrorDomain];
}

- (BOOL)b_isAppErrorWithCode:(BAppErrorCode)code
{
    return [self b_isAppError] && (self.code == code);
}

@end
