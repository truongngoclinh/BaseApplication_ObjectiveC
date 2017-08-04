//
//  NSError+CPRegisterFormatter.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+CPFormatter.h"

@interface NSError (CPRegisterFormatter)

- (NSString *)cp_formattedRegisterRequestOTPMessage;
- (NSString *)cp_formattedRegisterRequestRegisterMessage;

@end
