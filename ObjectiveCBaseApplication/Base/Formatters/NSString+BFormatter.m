//
//  NSString+BFormatter.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSString+BFormatter.h"

@implementation NSString (BFormatter)

+ (NSDictionary *)b_normalAttributesForStyle:(BStringFormatterStyle)style
{
    switch (style) {
        case BStringFormatterStyleAlertDefault:
            return @{ NSFontAttributeName : [BTheme lightFontOfSize:16],
                      NSForegroundColorAttributeName : [BTheme textColor] };
        default:
            NSParameterAssert(NO);
            break;
    }
    return nil;
}

+ (NSDictionary *)b_capturedAttributesForStyle:(BStringFormatterStyle)style
{
    switch (style) {
        case BStringFormatterStyleAlertDefault:
            return @{ NSFontAttributeName : [BTheme mediumFontOfSize:16],
                      NSForegroundColorAttributeName : [BTheme textColorMain] };
        default:
            NSParameterAssert(NO);
            break;
    }
    return nil;
}


- (NSAttributedString *)b_attributedStringByParsingRegex:(NSString *)regex style:(BStringFormatterStyle)style
{
    return [self b_attributedStringByParsingRegex:regex
                                  normalAttributes:[NSString b_normalAttributesForStyle:style]
                                capturedAttributes:[NSString b_capturedAttributesForStyle:style]];
}

- (NSAttributedString *)b_attributedStringByParsingRegex:(NSString *)regex
                                         normalAttributes:(NSDictionary *)normalAttributes
                                       capturedAttributes:(NSDictionary *)capturedAttributes
{
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:NSRegularExpressionUseUnicodeWordBoundaries
                                                                                  error:nil];
    
    NSMutableAttributedString *finalAttrString = [[NSMutableAttributedString alloc] initWithString:self attributes:normalAttributes];
    __block NSUInteger offset = 0;
    
    [expression enumerateMatchesInString:self
                                 options:0
                                   range:NSMakeRange(0, self.length)
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop2)
     {
         NSParameterAssert([result numberOfRanges] == 2);
         
         NSString *capturedText = [self substringWithRange:[result rangeAtIndex:1]];
         NSAttributedString *boldAttrString = [[NSAttributedString alloc] initWithString:capturedText attributes:capturedAttributes];
         
         // Replace text
         NSRange offsetRange = NSMakeRange(result.range.location - offset, result.range.length);
         [finalAttrString replaceCharactersInRange:offsetRange withAttributedString:boldAttrString];
         offset += result.range.length - boldAttrString.length;
     }];
    
    return [finalAttrString copy];
}

@end
