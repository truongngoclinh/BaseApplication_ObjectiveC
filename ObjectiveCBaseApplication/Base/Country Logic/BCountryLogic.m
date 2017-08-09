//
//  BCountryLogic.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BCountryLogic.h"
#import "BVietNamLogic.h"
#import "BGeneralLogic.h"

@implementation BCountryLogic

+ (id<BCountryLogicProtocol>)currentCountryLogic
{
    static id<BCountryLogicProtocol> countryLogic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef VN
        countryLogic = [[BVietnamLogic alloc] init];
#elif EN
        countryLogic = [[BGeneralLogic alloc] init];
#else
        NSParameterAssert(NO);
#endif
    });
    
    return countryLogic;
}

@end
