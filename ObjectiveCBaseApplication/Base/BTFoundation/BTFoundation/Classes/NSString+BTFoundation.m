//
//  NSString+BTAdditions.m
//  BeeTalk
//
//  Created by garena on 17/4/14.
//  Copyright (c) 2014 Garena. All rights reserved.
//

#import "NSString+BTFoundation.h"
#import "BTEmojiUnicodes.h"
#import <CommonCrypto/CommonDigest.h>

static NSArray *kBTEmojiUnicodeStrings = nil;

@implementation BTTextComponent

+ (instancetype)createNormalTextComponent:(NSString *)data
{
    BTTextComponent *text = [[BTTextComponent alloc] init];
    text.data = data;
    text.isEmoji = NO;
    return text;
}

+ (instancetype)createEmojiTextComponent:(NSString *)data
{
    BTTextComponent *emoji = [[BTTextComponent alloc] init];
    emoji.data = data;
    emoji.isEmoji = YES;
    return emoji;
}

@end

@implementation NSString (BTFoundation)

-(NSString *)bt_SHA256
{
    if (self.length == 0) {
        return nil;
    }

    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes, (uint32_t)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    NSParameterAssert(output.length);

    return output;
}

#pragma mark - Compoesed Characters
- (NSUInteger)bt_composedCharacterLength
{
    __block NSUInteger count = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              count++;
                          }];
    return count;
}

- (NSString *)bt_substringToComposedCharacterLength:(NSUInteger)length
{
    if (length == 0) {
        return @"";
    }

    __block NSUInteger charCount = 0, index = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              charCount++;
                              index = NSMaxRange(substringRange);

                              if (charCount == length) {
                                  *stop = YES;
                              }
                          }];
    NSParameterAssert(index <= self.length);
    return [self substringToIndex:index];
}

#pragma mark - Equality
+ (BOOL)bt_isStr:(NSString *)str1 sameAs:(NSString *)str2
{
    if (str1.length == 0 && str2.length == 0) {
        return YES;
    }

    return [str1 isEqualToString:str2];
}

#pragma mark - Hex
- (NSData *)bt_dataFromHexString
{
    char const *chars = self.UTF8String;
    NSUInteger charCount = strlen(chars);
    if (charCount % 2 != 0) {
        return nil;
    }

    NSUInteger byteCount = charCount / 2;

    NSMutableData *data = [NSMutableData dataWithLength:byteCount];
    uint8_t *bytes = (uint8_t *)data.mutableBytes;

    for (int i = 0; i < byteCount; ++i) {
        unsigned int value;
        sscanf(chars + i * 2, "%2x", &value);
        bytes[i] = value;
    }

    return data;
}

#pragma mark - Length in Bytes
- (NSString *)bt_substringToByteLength:(NSUInteger)length
{
    return [self bt_substringToByteLength:length selectedRange:NSMakeRange(0, self.length)];
}

- (NSString *)bt_substringToByteLength:(NSUInteger)length selectedRange:(NSRange)range
{
    NSParameterAssert(range.location + range.length <= self.length);
    NSString *substringAfterRange = range.location+range.length == self.length ? @"" : [self substringFromIndex:range.location + range.length];
    NSString *substringBeforeRange = [self substringToIndex:range.location];
    __block NSUInteger bytes = [substringBeforeRange lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + [substringAfterRange lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    __block NSUInteger index = 0;
    [self enumerateSubstringsInRange:range
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              bytes += [substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                              if (bytes > length) {
                                  *stop = YES;
                              } else {
                                  index += substringRange.length;
                              }
                          }];

    NSParameterAssert(index <= range.length + 1);
    NSString *substringWithinRange = [self substringWithRange:NSMakeRange(range.location, index)];
    return [NSString stringWithFormat:@"%@%@%@", substringBeforeRange, substringWithinRange, substringAfterRange];
}

#pragma mark - Trimming
- (NSString *)bt_stringByTrimmingLeadingAndTailingWhitespaces
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)bt_stringByRemoveAllLinebreaks
{
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (NSString *)bt_stringByTrimmingLeadingWhitespaces
{
    NSInteger i = 0;

    while ((i < [self length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

#pragma mark - Words
- (NSString *)bt_substringOfWordAtIndex:(NSUInteger)index
{
    NSUInteger wordStartIndex = [self bt_indexOfWordStartAtIndex:index];
    NSUInteger wordEndIndex = [self bt_indexOfWordEndAtIndex:index];

    return [self substringWithRange:NSMakeRange(wordStartIndex, wordEndIndex - wordStartIndex)];
}

- (NSUInteger)bt_indexOfWordEndAtIndex:(NSUInteger)index
{
    NSUInteger wordEndIndex = index;
    while (wordEndIndex < self.length &&
           ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:wordEndIndex]]) {
        wordEndIndex++;
    }
    return wordEndIndex;
}

- (NSUInteger)bt_indexOfWordStartAtIndex:(NSUInteger)index
{
    NSUInteger wordStartIndex = index;
    while (wordStartIndex > 0 &&
           ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:wordStartIndex - 1]]) {
        wordStartIndex--;
    }
    return wordStartIndex;
}

#pragma mark - Emoji
+ (BOOL)bt_isEmoji:(NSString *)string
{
    return [[BTEmojiUnicodes sharedInstance].unicodes containsObject:string];
}

- (NSArray *)bt_separateByEmojiComponent
{
    __block NSMutableArray *elements = [NSMutableArray array];

    // string before the protential emoji unicode
    __block NSMutableString *accumulatedText = [NSMutableString string];
    // iOS emoji can be two unicode combined
    __block NSString *previosUnicodeStr = nil;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if (substringRange.length > 1) {

                                  if ([NSString bt_isEmoji:substring]) {
                                      // this iOS emoji is made up by one unicode

                                      if (previosUnicodeStr) {
                                          // append previous protential unicode to the text element
                                          [accumulatedText appendString:previosUnicodeStr];
                                          previosUnicodeStr = nil;
                                      }

                                      if (accumulatedText.length > 0) {
                                          BTTextComponent *component = [BTTextComponent createNormalTextComponent:accumulatedText];
                                          [elements addObject:component];
                                          accumulatedText = [NSMutableString string];
                                      }

                                      BTTextComponent *component = [BTTextComponent createEmojiTextComponent:substring];
                                      [elements addObject:component];

                                  } else if (previosUnicodeStr) {

                                      NSString *fullString = [previosUnicodeStr stringByAppendingString:substring];
                                      if ([NSString bt_isEmoji:fullString]) {
                                          // this iOS emoji is a combination of two unicodes

                                          if (accumulatedText.length > 0) {
                                              BTTextComponent *component = [BTTextComponent createNormalTextComponent:accumulatedText];
                                              [elements addObject:component];
                                              accumulatedText = [NSMutableString string];
                                          }

                                          BTTextComponent *component = [BTTextComponent createEmojiTextComponent:fullString];
                                          [elements addObject:component];

                                          previosUnicodeStr = nil;
                                      } else {

                                          // previous unicode is not part of any iOS emoji
                                          [accumulatedText appendString:previosUnicodeStr];
                                          previosUnicodeStr = substring;

                                      }

                                  } else {

                                      // this unicode may be combined w/ next unicode to form an iOS emoji
                                      previosUnicodeStr = substring;
                                  }

                              } else {

                                  // this unicode cannot be an iOS emoji unicode
                                  if (previosUnicodeStr) {
                                      [accumulatedText appendString:previosUnicodeStr];
                                      previosUnicodeStr = nil;
                                  }
                                  [accumulatedText appendString:substring];
                              }
                          }];

    if (previosUnicodeStr) {
        [accumulatedText appendString:previosUnicodeStr];
        previosUnicodeStr = nil;
    }
    
    if (accumulatedText.length) {
        BTTextComponent *component = [BTTextComponent createNormalTextComponent:accumulatedText];
        [elements addObject:component];
    }
    
    return [elements copy];
    
}

- (NSString *)bt_trimEmoji
{
    NSArray *components = [self bt_separateByEmojiComponent];
    NSMutableString *str = [NSMutableString string];
    for (BTTextComponent *component in components) {
        if (! component.isEmoji) {
            [str appendString:component.data];
        }
    }
    return [str copy];
}

#pragma mark - Unicode
+ (NSString *)bt_emojiUnicodeStringFromHexString:(NSString *)str
{
    return [self bt_emojiUnicodeFromHexString:str isCombined:YES];
}

+ (NSArray *)bt_emojiUnicodesFromHexString:(NSString *)str separatedBy:(NSString *)separation;
{
    NSArray *arr = [str componentsSeparatedByString:separation];
    __block NSMutableArray *unicodeArr = [NSMutableArray arrayWithCapacity:arr.count];
    [arr enumerateObjectsUsingBlock:^(NSString *s, NSUInteger idx, BOOL *stop) {
        if (s.length) {
            NSString *unicode = [self bt_emojiUnicodeFromHexString:s isCombined:idx == 0];
            [unicodeArr addObject:unicode];
        }
    }];
    return [unicodeArr copy];
}

+ (NSString *)bt_emojiUnicodeFromHexString:(NSString *)str isCombined:(BOOL)flag
{
    NSParameterAssert(str.length == 8 // normal unicode
                      || str.length == 9 // keycap
                      || str.length == 17 // keycap alternative
                      || str.length == 16); // symbols & region flags

    if (flag && str.length == 16) {
        NSString *firstHalf = [self bt_emojiUnicodeFromHexString:[str substringToIndex:8] isCombined:NO];
        NSString *secondHalf = [self bt_emojiUnicodeFromHexString:[str substringFromIndex:8] isCombined:NO];
        return [firstHalf stringByAppendingString:secondHalf];
    }

    NSString *hexStr = str;
    NSString *leading = nil;
    if (str.length % 8 != 0) {
        hexStr = [str substringFromIndex:1];
        leading = [str substringToIndex:1];
    }
    int len = (int) (hexStr.length / 8 * 4);
    char chars[len];

    int index = 0;
    while (index < len) {
        NSString *charCode = [hexStr substringWithRange:NSMakeRange(index * 2, 8)];
        unsigned unicodeInt = 0;
        [[NSScanner scannerWithString:charCode] scanHexInt:&unicodeInt];
        chars[index] = (unicodeInt >> 24) & (1 << 24) - 1;
        chars[index + 1] = (unicodeInt >> 16) & (1 << 16) - 1;
        chars[index + 2] = (unicodeInt >> 8) & (1 << 8) - 1;
        chars[index + 3] = unicodeInt & (1 << 8) - 1;
        index += 4;
    }

    NSString *unicodeString = [[NSString alloc] initWithBytes:chars
                                                       length:len
                                                     encoding:NSUTF32StringEncoding];
    if (leading) {
        unicodeString = [leading stringByAppendingString:unicodeString];
    }
    return unicodeString;
}

@end
