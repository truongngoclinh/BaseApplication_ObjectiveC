//
//  NSString+BFormatter.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>

static NSString *const BStringFormatterBracketRegex = @"\\[(.*?)\\]";

typedef NS_ENUM(NSInteger, BStringFormatterStyle)
{
    /** Normal:   textColor, lightFont, 18
        Captured: textColorMain, mediumFont, 18 */
    BStringFormatterStyleAlertDefault = 1,
};

@interface NSString (BFormatter)

- (NSAttributedString *)b_attributedStringByParsingRegex:(NSString *)regex
                                                    style:(BStringFormatterStyle)style;

- (NSAttributedString *)b_attributedStringByParsingRegex:(NSString *)regex
                                         normalAttributes:(NSDictionary *)normalAttributes
                                       capturedAttributes:(NSDictionary *)capturedAttributes;

@end
