//
//  NSError+BAppFormatter.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+BAppFormatter.h"

@implementation NSError (BAppFormatter)

- (NSString *)b_formattedAppMessage
{
    NSString *message = nil;
    switch ((BAppErrorCode)self.code) {
        case BAppErrorCodePasscodeUnlockCancelled:
            message = TXT(@"error_passcode_unlock_required");
            break;
        case BAppErrorCodeMobileNumberInvalid:
            message = TXT(@"error_mobile_invalid");
            break;
        case BAppErrorCodeReceiptTemplateUnsupported:
            message = TXT(@"error_receipt_template_unsupported");
            break;
        case BAppErrorCodeMantleObjectInvalid:
            message = TXT(@"error_response_invalid");
            break;
        case BAppErrorCodeIdentityNumberContainsNonDigits:
        case BAppErrorCodeIdentityNumberIncorrectLength:
        case BAppErrorCodeIdentityNumberInvalid:
            message = TXT(@"error_invalid_identity_number");
            break;
        case BAppErrorCodePostalCodeInvalid:
            message = TXT(@"error_invalid_postal_code");
            break;
        default:
            NSParameterAssert(NO);
            break;
    }
    return message;
}

@end
