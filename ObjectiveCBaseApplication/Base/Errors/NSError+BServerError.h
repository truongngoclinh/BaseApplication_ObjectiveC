//
//  NSError+BServerError.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>
#import "NSError+BError.h"

extern NSString *const BServerErrorDomain;

/** key in userInfo containing dictionary of response */
extern NSString *const BServerResponseKey;

/** key in response containing provider system error code */
extern NSString *const BServerProviderSystemErrorCodeKey;

typedef NS_ENUM(NSUInteger, BServerErrorCode) {
    BServerErrorCodeHttpMethodDisallowed               = 1,
    BServerErrorCodeParameterRequired                  = 2,
    BServerErrorCodeParameterIllegal                   = 3,
    BServerErrorCodeRetailerDoesNotExist               = 4,
    BServerErrorCodeRetailerIsSuspended                = 5,
    BServerErrorCodeOtpRequired                        = 6,
    BServerErrorCodeOtpIllegal                         = 7,
    BServerErrorCodeOtpRateLimit                       = 8,
    BServerErrorCodeLoginRequired                      = 9,
};

@interface NSError (BServerError)

- (BOOL)b_isServerError;
- (BOOL)b_isServerErrorWithCode:(BServerErrorCode)code;

@end
