//
//  NSString+BAdditions.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BAdditions)

#pragma mark - Character

/* Check whether or not the given string is empty */
+ (BOOL)b_isEmpty:(NSString * _Nullable)string;

- (BOOL)b_containsSpecialCharacters;
- (NSString * _Nullable)b_stringWithoutSpecialCharacters;

- (BOOL)b_containsOnlyDecimalDigits;
- (NSString * _Nullable)b_stringWithOnlyDecimalDigits;

#pragma mark - Constructor

+ (NSString * _Nullable)b_stringWithObject:(id)object;

#pragma mark - Email

- (BOOL)b_isValidEmail;

#pragma mark - QRCode Image

/** @param size: length in points. Scaling of screen will be applied. */
- (CGImageRef)new_BQRCodeCGImageWithSize:(CGFloat)size;
- (CGImageRef)new_BQRCodeCGImageWithSize:(CGFloat)size screenScale:(CGFloat)screenScale;

#pragma mark - URL

- (NSString *)b_URLEncodedQueryString;

- (NSString *)b_URLDecodedQueryString;

- (NSString *)b_escapeHTML;

- (NSString *)b_unescapeHTML;

- (NSString *)b_percentEncodedURLString;

- (NSString *)b_fileNameFromURL;

#pragma mark - Hash

- (NSString *)b_MD5Digest;

#pragma mark - Trimming

- (NSString *)b_stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters;
- (NSString *)b_stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)b_stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

#pragma mark - String Manipulation

- (NSString *)b_stringByReplacingFirstOccurrenceOfString:(NSString *)target withString:(NSString *)replacement;

/* To fix an issue where -containsString is not supported on iOS 7 */
- (BOOL)b_containsString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
