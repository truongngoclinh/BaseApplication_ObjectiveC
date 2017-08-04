//
//  NSError+BRegisterFormatter.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+BRegisterFormatter.h"

@implementation NSError (BRegisterFormatter)

- (NSString *)b_formattedRegisterRequestOTPMessage
{
    return [self b_formattedMesssageForServerError:^NSString *(BServerErrorCode code, NSString *message) {
        switch (code) {
            case BServerErrorCodeOtpRateLimit:
                message = TXT(@"error_otp_limit");
                break;
            case BServerErrorCodeAccountAlreadyExist:
                message = TXT(@"error_registration_account_exist");
                break;
            case BServerErrorCodeParameterIllegal:
                message = TXT(@"error_mobile_invalid");
                break;
            case BServerErrorCodeIdentityNumberAlreadyExist:
                message = TXT(@"error_identity_number_existed");
                break;
            default:
                NSParameterAssert(NO);
                break;
        }
        return message;
    }];
}

- (NSString *)b_formattedRegisterRequestRegisterMessage
{
    return [self b_formattedMesssageForServerError:^NSString *(BServerErrorCode code, NSString *message) {
        switch (code) {
            case BServerErrorCodeParameterIllegal:
            case BServerErrorCodeOtpIllegal:
                message = TXT(@"error_otp_invalid");
                break;
            case BServerErrorCodeAccountAlreadyExist:
                message = TXT(@"error_registration_account_exist");
                break;
            case BServerErrorCodeIdentityNumberAlreadyExist:
                message = TXT(@"error_identity_number_existed");
                break;
            default:
                NSParameterAssert(NO);
                break;
        }
        
        return message;
    }];
}

@end
