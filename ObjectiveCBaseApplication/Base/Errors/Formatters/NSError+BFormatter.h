//
//  NSError+BFormatter.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>
#import "NSError+BServerError.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * _Nonnull (^BFormatterServerErrorMessageBlock)(BServerErrorCode code, NSString *message);

@interface NSError (BFormatter)

- (NSString *)b_formattedMesssage;
- (NSString *)b_formattedMesssageForServerError:(BFormatterServerErrorMessageBlock _Nullable)block;

@end

NS_ASSUME_NONNULL_END
