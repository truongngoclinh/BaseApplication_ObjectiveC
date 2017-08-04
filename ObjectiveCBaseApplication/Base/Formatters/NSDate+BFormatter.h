//
//  NSDate+BFormatter.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BFormatter)

/** dd-MM-yyyy */
- (NSString *)b_formattedDisplayDate;

/** dd-MM-yyyy HH:mm */
- (NSString *)b_formattedDisplayDateTime;

/** Method is slow. Instantiate a BFormatter everytime method is called. */
- (NSString *)b_formattedStringWithDateFormat:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
