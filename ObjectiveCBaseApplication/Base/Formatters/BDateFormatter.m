//
//  BDateFormatter.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BDateFormatter.h"
#import "BLang.h"

@implementation BDateFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.locale = [NSLocale localeWithLocaleIdentifier:[BLang sharedInstance].currentLanguageCode];
    }
    return self;
}

@end
