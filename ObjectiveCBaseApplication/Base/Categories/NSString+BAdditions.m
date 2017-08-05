//
//  NSString+BAdditions.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSString+BAdditions.h"

#import "NSString+SAMAdditions.h"

static NSString *const specialCharacters = @"~@#$%^&*()!+-";

@implementation NSString (BAdditions)

#pragma mark - Character

+ (BOOL)b_isEmpty:(NSString * _Nullable)string
{
    if (string == nil) {
        return YES;
    }
    
    NSString *trimmedString = [string b_stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters];
    
    return (trimmedString.length == 0);
}

- (BOOL)b_containsSpecialCharacters
{
    NSString *afterText = [self b_stringWithoutSpecialCharacters];
    return [afterText isEqualToString:self];
}

- (NSString *)b_stringWithoutSpecialCharacters
{
    NSString *pattern = [NSString stringWithFormat:@"[%@]", specialCharacters];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:0
                                  error:nil];
    NSRange visibleRange = NSMakeRange(0, self.length);
    return [regex stringByReplacingMatchesInString:self options:0 range:visibleRange withTemplate:@""];
}

- (BOOL)b_containsOnlyDecimalDigits
{
    NSCharacterSet *decimalDigitSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    
    return [decimalDigitSet isSupersetOfSet:stringSet];
}

- (NSString *)b_stringWithOnlyDecimalDigits
{
    NSCharacterSet *nonDecimalSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [self componentsSeparatedByCharactersInSet:nonDecimalSet];
    return [components componentsJoinedByString:@""];
}

#pragma mark - Constructor

+ (NSString *)b_stringWithObject:(id)object
{
    NSString *string;
    if ([object isKindOfClass:[NSString class]]) {
        string = object;
    } else if ([object respondsToSelector:@selector(stringValue)]) {
        string = [object stringValue];
    }
    return string;
}

#pragma mark - Email

- (BOOL)b_isValidEmail
{
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *regex = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark - QRCode Image

- (CGImageRef)new_BQRCodeCGImageWithSize:(CGFloat)size
{
    return [self new_BQRCodeCGImageWithSize:size screenScale:[UIScreen mainScreen].scale];
}

- (CGImageRef)new_BQRCodeCGImageWithSize:(CGFloat)size screenScale:(CGFloat)screenScale
{
    // Code snippet from:
    // http://stackoverflow.com/questions/22374971/ios-7-core-image-qr-code-generation-too-blur
    
    // Discussion on memory management:
    // http://stackoverflow.com/questions/1402148/imagewithcgimage-and-memory

    // size in pixels
    size = size * screenScale;
    
    // Setup the QR filter with our string
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [self dataUsingEncoding:NSISOLatin1StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *image = [filter valueForKey:@"outputImage"];
    
    // Calculate the size of the generated image and the scale for the desired image size
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = size / CGRectGetWidth(extent);
    
    // Since CoreImage nicely interpolates, we need to create a bitmap image that we'll draw into
    // a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    
    return scaledImage;
}

#pragma mark - URL

- (NSString *)b_URLEncodedQueryString
{
    NSMutableCharacterSet *mutableCharacterSet = [[NSMutableCharacterSet alloc] init];
    [mutableCharacterSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
    [mutableCharacterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@".-_~"]];
    
    NSString *resultString = [self stringByAddingPercentEncodingWithAllowedCharacters:[mutableCharacterSet copy]];
    
    if (resultString.length > 0) {
        return resultString;
    }
    
    NSParameterAssert(NO);
    
    return self;
}

- (NSString *)b_URLDecodedQueryString
{
    NSString *resultString = [self stringByRemovingPercentEncoding];
    
    if (resultString.length > 0) {
        return resultString;
    }
    
    NSParameterAssert(NO);
    
    return self;
}

- (NSString *)b_escapeHTML
{
    return [self sam_escapeHTML];
}

- (NSString *)b_unescapeHTML
{
    return [self sam_unescapeHTML];
}

- (NSString *)b_percentEncodedURLString
{
    NSMutableCharacterSet *allowedCharacterSet = [[NSMutableCharacterSet alloc] init];
    [allowedCharacterSet formUnionWithCharacterSet:[NSCharacterSet URLHostAllowedCharacterSet]];
    [allowedCharacterSet formUnionWithCharacterSet:[NSCharacterSet URLPathAllowedCharacterSet]];
    [allowedCharacterSet formUnionWithCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [allowedCharacterSet formUnionWithCharacterSet:[NSCharacterSet URLUserAllowedCharacterSet]];
    [allowedCharacterSet formUnionWithCharacterSet:[NSCharacterSet URLPasswordAllowedCharacterSet]];
    [allowedCharacterSet formUnionWithCharacterSet:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSString *resultString = [[self stringByRemovingPercentEncoding] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    if (resultString.length > 0) {
        return resultString;
    }
    
    NSParameterAssert(NO);
    
    return self;
}

- (NSString *)b_fileNameFromURL
{
    return [self b_URLEncodedQueryString];
}

#pragma mark - Hash

- (NSString *)b_MD5Digest
{
    return [self sam_MD5Digest];
}

#pragma mark - Trimming

- (NSString *)b_stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)b_stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)b_stringByTrimmingLeadingWhitespaceAndNewlineCharacters
{
    return [self b_stringByTrimmingLeadingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)b_stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    
    //return [self substringToIndex:rangeOfLastWantedCharacter.location + 1]; // Non-inclusive
    
    //FIX by Weijian: if the last character is an emoji(2 chars), we need to substring to the end of the emoji
    return [self substringToIndex:rangeOfLastWantedCharacter.location + rangeOfLastWantedCharacter.length]; // Non-inclusive
}

- (NSString *)b_stringByTrimmingTrailingWhitespaceAndNewlineCharacters
{
    return [self b_stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - String Manipulation

- (NSString *)b_stringByReplacingFirstOccurrenceOfString:(NSString *)target withString:(NSString *)replacement
{
    NSRange range = [self rangeOfString:target];
    if (range.location != NSNotFound) {
        return [self stringByReplacingCharactersInRange:range withString:replacement];
    } else {
        return self;
    }
}

- (BOOL)b_containsString:(NSString *)string
{
    if (SYSTEM_VERSION_LESS_THAN(@"8")) {
        NSRange range = [self rangeOfString:string];
        return range.location != NSNotFound;
    } else {
        return [self containsString:string];
    }
}

@end
