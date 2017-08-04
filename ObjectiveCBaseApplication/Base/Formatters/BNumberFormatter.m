//
//  BNumberFormatter.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BNumberFormatter.h"
#import "BCountryLogic.h"

@implementation BNumberFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locale = [NSLocale localeWithLocaleIdentifier:[BCountryLogic currentCountryLogic].defaultLanguageCode];
    }
    return self;
}

@end
