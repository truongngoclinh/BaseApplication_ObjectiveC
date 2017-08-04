//
//  NSError+BAppError.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>
#import "NSError+BError.h"

extern NSString *const BAppErrorDomain;

typedef NS_ENUM(NSUInteger, BAppErrorCode)
{
    BAppErrorCodePasscodeUnlockCancelled               = 1, // BPasscodeManager
    BAppErrorCodeMobileNumberInvalid                   = 2, // BPhoneNumberManager
    BAppErrorCodeReceiptTemplateUnsupported            = 3, // BReceiptManager
    BAppErrorCodeMantleObjectInvalid                   = 4,
    BAppErrorCodeIdentityNumberContainsNonDigits       = 5, // BIdentityNumberManager
    BAppErrorCodeIdentityNumberIncorrectLength         = 6, // BIdentityNumberManager
    BAppErrorCodeIdentityNumberInvalid                 = 7, // BIdentityNumberManager
    BAppErrorCodePostalCodeInvalid                     = 8
};

@interface NSError (BAppError)

- (BOOL)b_isAppError;
- (BOOL)b_isAppErrorWithCode:(BAppErrorCode)code;

@end
