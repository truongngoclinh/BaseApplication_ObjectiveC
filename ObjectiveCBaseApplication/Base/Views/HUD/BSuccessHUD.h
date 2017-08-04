//
//  BSuccessHUD.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BBaseHUD.h"

extern const NSTimeInterval BSuccessHUDDefaultInterval;

@interface BSuccessHUD : BBaseHUD

@property (nonatomic, strong) NSString *text;

@end
