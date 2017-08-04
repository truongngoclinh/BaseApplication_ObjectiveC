//
//  NSError+BLoginFormatter.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+BLoginFormatter.h"

@implementation NSError (BLoginFormatter)

- (NSString *)b_formattedLoginRequestOTPMessage
{
    return [self b_formattedMesssageForServerError:^NSString *(BServerErrorCode code, NSString *message) {
        switch (code) {
            case BServerErrorCodeOtpRateLimit:
                message = TXT(@"error_otp_limit");
                break;
            default:
                NSParameterAssert(NO);
                break;
        }
        return message;
    }];
}

- (NSString *)b_formattedLoginRequestLoginWithOTPMessage
{
    return [self b_formattedMesssageForServerError:^NSString *(BServerErrorCode code, NSString *message) {
        switch (code) {
            case BServerErrorCodeParameterIllegal:
            case BServerErrorCodeOtpIllegal:
                message = TXT(@"error_otp_invalid");
                break;
            default:
                NSParameterAssert(NO);
                break;
        }
        return message;
    }];
}

@end
