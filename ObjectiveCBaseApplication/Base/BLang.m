//
//  BLang.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BLang.h"
#import "BCountryLogic.h"

BLogLevel(BLogLevelDebug);

@interface BLangItem : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *notificationID;

@end

@implementation BLangItem

@end

NSString *const BLangCodeEN = @"en";
NSString *const BLangCodeVN = @"vn";

static NSString *const kLanguageKey = @"BUDPreferredLanguageKey";
static NSString *const kLanguageDirectory = @"localized_resources/language";

static NSInteger kLanguageDefaultCodeInteger = 0;

@interface BLang ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, strong) NSArray *languages;
@property (nonatomic, strong) NSDictionary *localizedMap;
@property (nonatomic, strong) NSDictionary *englishMap;
@property (nonatomic, strong) NSArray *supportedLanguageCodes;
@property (nonatomic, strong) NSMutableDictionary *languageListData;

@end

@implementation BLang

+ (BLang *)sharedInstance
{
    static BLang *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BLang alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    });
    
    return instance;
}

- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self) {
        NSParameterAssert(userDefaults);
        _userDefaults = userDefaults;
        
        [self restoreLanguageCode];
        [self reloadLocalizedMap];
    }
    return self;
}

- (void)updateCurrentLanguageCode:(NSString *)languageCode
{
    if (!languageCode.length) {
        DDLogError(@"[%@] Language code is empty", self.class);
        languageCode = [BCountryLogic currentCountryLogic].defaultLanguageCode;
        NSParameterAssert(languageCode);
    }
    
    if (![self.supportedLanguageCodes containsObject:languageCode]) {
        DDLogError(@"[%@] Language code not supported:%@", self.class, languageCode);
        languageCode = self.supportedLanguageCodes[0];
        NSParameterAssert(NO);
    }
    
    if (![_currentLanguageCode isEqualToString:languageCode]) {
        self.currentLanguageCode = languageCode;
        [self reloadLocalizedMap];
        [self saveLanguageCode];
    }
}

- (void)setCurrentLanguageCode:(NSString *)currentLanguageCode
{
    NSParameterAssert(currentLanguageCode);
    _currentLanguageCode = currentLanguageCode;
}

- (NSInteger)currentLanguageIntegerCode
{
    __block NSInteger code = kLanguageDefaultCodeInteger;
    [self.languages enumerateObjectsUsingBlock:^(BLangItem *languageItem, NSUInteger idx, BOOL *stop) {
        if ([languageItem.filename isEqualToString:self.currentLanguageCode]) {
            code = [languageItem.notificationID integerValue];
            *stop = YES;
        }
    }];
    return code;
}

- (NSString *)displayNameForLanguageCode:(NSString *)languageCode
{
    __block NSString *displayName = nil;
    [self.languages enumerateObjectsUsingBlock:^(BLangItem *languageItem, NSUInteger idx, BOOL *stop) {
        if ([languageItem.filename isEqualToString:languageCode]) {
            displayName = languageItem.displayName;
            *stop = YES;
        }
    }];
    return displayName;
}

- (NSArray *)supportedLanguageCodes
{
    if (_supportedLanguageCodes == nil) {
        
        NSMutableArray *supportedLanguageCodes = [NSMutableArray arrayWithCapacity:self.languages.count];
        [self.languages enumerateObjectsUsingBlock:^(BLangItem *item, NSUInteger idx, BOOL *stop) {
            [supportedLanguageCodes addObject:item.filename];
        }];
        
        _supportedLanguageCodes = supportedLanguageCodes;
    }
    return _supportedLanguageCodes;
}

- (NSString *)localizedPhrase:(NSString *)phrase
{
    NSString *localizedPhrase = [self.localizedMap objectForKey:phrase];
    
    if (localizedPhrase == nil) {
        localizedPhrase = [self.englishMap objectForKey:phrase];
    }
    
    if (localizedPhrase == nil) {
        localizedPhrase = phrase;
    }
    
    return localizedPhrase;
}

#pragma mark - Save Load

- (void)restoreLanguageCode
{
    NSString *languageCode = [self.userDefaults valueForKey:kLanguageKey];
    if (!languageCode.length) {
        languageCode = [BCountryLogic currentCountryLogic].defaultLanguageCode;
    }
    
    DDLogInfo(@"[%@] Restored language:%@", self.class, languageCode);
    
    self.currentLanguageCode = languageCode;
}

- (void)saveLanguageCode
{
    [self.userDefaults setValue:self.currentLanguageCode forKey:kLanguageKey];
    [self.userDefaults synchronize];
    
    DDLogInfo(@"[%@] Saved language:%@", self.class, self.currentLanguageCode);
}

#pragma mark - Private Methods

- (NSArray *)languages
{
    if (_languages == nil) {
        NSError *error = nil;
        
        NSString *resource = [NSString stringWithFormat:@"%@/langs", kLanguageDirectory];
        NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
        
        NSData *languageListContents = [[NSFileManager defaultManager] contentsAtPath:path];
        
        NSDictionary *langsDictionary = [NSJSONSerialization JSONObjectWithData:languageListContents
                                                                        options:0
                                                                          error:&error];
        NSParameterAssert(error == nil);
        
        NSArray *langs = langsDictionary[@"langs"];
        
        NSMutableArray *languages = [NSMutableArray arrayWithCapacity:5];
        
        for (NSDictionary *langInfo in langs) {
            NSString *fileName = langInfo[@"name"];
            NSString *displayName = langInfo[@"display"];
            NSString *notification = langInfo[@"notification"];
            
            NSParameterAssert([fileName length]);
            NSParameterAssert([displayName length]);
            NSParameterAssert([notification length]);
            
            BLangItem *item = [[BLangItem alloc] init];
            item.filename = fileName;
            item.displayName = displayName;
            item.notificationID = notification;
            
            [languages addObject:item];
        }
        
        [languages sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"notificationID" ascending:YES]]];
        
        _languages = languages;
        
        NSParameterAssert([_languages count]);
    }
    
    return _languages;
}

- (void)reloadLocalizedMap
{
    NSParameterAssert([self.supportedLanguageCodes containsObject:self.currentLanguageCode]);
    self.localizedMap = [self localizedMapForLanguageCode:self.currentLanguageCode];
    
    // We load an englishMap if language is not english
    if (![self.currentLanguageCode isEqualToString:BLangCodeEN]) {
        self.englishMap = [self localizedMapForLanguageCode:BLangCodeEN];
    }
}

- (NSDictionary *)localizedMapForLanguageCode:(NSString *)code
{
    NSError *error = nil;
    
    NSString *resource = [NSString stringWithFormat:@"%@/%@", kLanguageDirectory, code];
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *languageMap = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] objectForKey:@"translation"];
    
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:languageMap.count];
    
    [languageMap enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *text, BOOL *stop) {
        NSString *convertedText = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        [map setObject:convertedText forKey:key];
    }];
    
    if (error) {
        [NSException raise:@"Invalid JSON" format:@"%@", [error localizedDescription]];
    }
    
    return map;
}

@end
