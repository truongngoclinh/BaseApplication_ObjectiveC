//
//  NSString+BTAdditions.h
//  BeeTalk
//
//  Created by garena on 17/4/14.
//  Copyright (c) 2014 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTextComponent : NSObject

@property (nonatomic, strong) NSString *data;
@property (nonatomic, assign) BOOL isEmoji;

+ (instancetype)createNormalTextComponent:(NSString *)data;
+ (instancetype)createEmojiTextComponent:(NSString *)data;

@end

@interface NSString (BTFoundation)

/**
Computes SHA256 of the given string
@return SHA256 of the string. Returns nil if string is empty
*/
- (NSString *)bt_SHA256;

#pragma mark - Composed Characters
/**
Computes the length of the string.
2 bytes char is considered as 1 char
*/
- (NSUInteger)bt_composedCharacterLength;

/**
Returns a substring that uses composed characters length
If provided length is greater than string length, returns the entire string instead of throwing exception
*/
- (NSString *)bt_substringToComposedCharacterLength:(NSUInteger)length;

#pragma mark - Equality
/**
Check Str for equality
If str1 is nil and str2 is empty and vice versa, return YES
If str1 is nil and str2 is nil, return YES
Finally runs a isEqualToString check
*/
+ (BOOL)bt_isStr:(NSString *)str1 sameAs:(NSString *)str2;

#pragma mark - Hex
/**
 Decode the string of Hex codes
 @return an NSData object decoded from the string of Hex codes, return nil if format is wrong
 */
- (NSData *)bt_dataFromHexString;

#pragma mark - Length in Bytes
/**
 Trim the string to a maximum length in bytes
 The characters in original string is iterated through by character
 Note some characters such as Chinese are represented in multiple bytes,
 so actual bytes of the substring returned may be less than length.
 The original string will be returned if length is larger than total bytes of the original string.
 @param length      the length of substring in bytes.
 @return            a substring with a maximum length in bytes
 */
- (NSString *)bt_substringToByteLength:(NSUInteger)length;

/**
 Trim the substring in range so the total length in bytes is not larger than length.
 If the bytes of string beyond the range is larger or equal to length,
 it will trim all characters in range.
 The characters in original string is iterated through by character
 Note some characters such as Chinese are represented in multiple bytes,
 so actual bytes of the substring in range returned may be less than length.
 @param length      the length of substring in bytes.
 @param range       range of the original string to be trimmed. Range must be within the original string. range.location is the starting index and range.location + range.length is the ending index, both inclusive. Note that range is counted in terms of utf-16 char instead of composed char, as a result, 4-byte unicode char (which has length of 2) needs to be handled with special care
 @return            a substring of the original string, by trimming the substring in range to a maximum length in bytes.
 */
- (NSString *)bt_substringToByteLength:(NSUInteger)length selectedRange:(NSRange)range;

#pragma mark - Trimming
/**
 Trim only the leading and tailing whitespaces (line breaks are preserved)
 @return    a substring containing no leading nor tailing whitespaces
 */
- (NSString *)bt_stringByTrimmingLeadingAndTailingWhitespaces;

/**
 Remove all line breaks (whitespaces are preserved)
 @return    a substring containing no line breaks
 */
- (NSString *)bt_stringByRemoveAllLinebreaks;

/**
 Trim only the leading whitespaces
 @return    a substring containing no leading whitespaces
 */
- (NSString *)bt_stringByTrimmingLeadingWhitespaces;

#pragma mark - Words
/**
 Find the word located at index.
 Words are separated by whitespaceAndNewlineCharacterSet.
 @code
 // Returns @"there!"
 [@"Hello there!" substringOfWordAtIndex:8]
 @endcode
 @return String of the word located at index.
 */
- (NSString *)bt_substringOfWordAtIndex:(NSUInteger)index;

/**
 Find the position of the end of word located at index.
 Words are separated by whitespaceAndNewlineCharacterSet.
 @code
 // Returns 11
 [@"Hello there!" indexOfWordEndAtIndex:8]
 @endcode
 @return String of the word located at index.
 */
- (NSUInteger)bt_indexOfWordEndAtIndex:(NSUInteger)index;

/**
 Find the position of the start of word located at index.
 Words are separated by whitespaceAndNewlineCharacterSet.
 @code
 // Returns 6
 [@"Hello there!" indexOfWordStartAtIndex:8]
 @endcode
 @return String of the word located at index.
 */
- (NSUInteger)bt_indexOfWordStartAtIndex:(NSUInteger)index;

#pragma mark - Emoji
/**
 Check whether the given string is an Emoji
 @return    YES is the string is an Emoji unicode string
 */
+ (BOOL)bt_isEmoji:(NSString *)string;

/**
 Trim all Emojis
 @return    a substring containing no emoji unicodes
 */
- (NSString *)bt_trimEmoji;

/**
 Separate the original string into components, by Emoji unicodes
 @return    an array of BTTextComponent objects, eaching representing either a normal text or an Emoji unicode
 */
- (NSArray *)bt_separateByEmojiComponent;

#pragma mark - Emoji Unicode
/**
 Parse Hex string into unicode string
 @param str the Hex format of Emoji unicode. str must be of length 8 or 16
 @return    a unicode string decoded from the Hex string
 */
+ (NSString *)bt_emojiUnicodeStringFromHexString:(NSString *)str;

/**
 Parse Hex string to an Array of Emoji unicode strings
 @param str         the Hex string of multiple Emoji unicodes, each unicodes must be of length 8 or 16
 @param separation  the string used to split string into multiple Emoji Hex strings, such as whitespace or comma
 @return            an Array of unicode strings decoded from the Hex string
 */
+ (NSArray *)bt_emojiUnicodesFromHexString:(NSString *)str separatedBy:(NSString *)separation;

@end
