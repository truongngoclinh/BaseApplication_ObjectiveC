//
//  BLang.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TXT(var) [[BLang sharedInstance] localizedPhrase:(var)]

extern NSString *const BLanguageCodeEN;
extern NSString *const BLanguageCodeVN;

@interface BLang : NSObject

@property (nonatomic, strong, readonly) NSString *currentLanguageCode;
@property (nonatomic, assign, readonly) NSInteger currentLanguageIntegerCode;
@property (nonatomic, strong, readonly) NSArray *supportedLanguageCodes;

+ (BLang *)sharedInstance;

- (void)updateCurrentLanguageCode:(NSString *)languageCode;

- (NSString *)displayNameForLanguageCode:(NSString *)languageCode;
- (NSString *)localizedPhrase:(NSString *)phrase;

@end
