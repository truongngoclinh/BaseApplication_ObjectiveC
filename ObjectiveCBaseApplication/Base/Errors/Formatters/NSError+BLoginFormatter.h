//
//  NSError+BLoginFormatter.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>
#import "NSError+BFormatter.h"

@interface NSError (BLoginFormatter)

- (NSString *)b_formattedLoginRequestOTPMessage;
- (NSString *)b_formattedLoginRequestLoginWithOTPMessage;

@end
