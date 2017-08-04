//
//  BErrorHUD.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BBaseHUD.h"

extern const NSTimeInterval BErrorHUDDefaultInterval;
extern const NSTimeInterval BErrorHUDLongInterval;

@interface BErrorHUD : BBaseHUD

@property (nonatomic, strong) NSString *text;

@end
