//
//  BCountryLogic.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCountryLogicProtocol.h"

@interface BCountryLogic : NSObject

+ (id<BCountryLogicProtocol>)currentCountryLogic;

@end
