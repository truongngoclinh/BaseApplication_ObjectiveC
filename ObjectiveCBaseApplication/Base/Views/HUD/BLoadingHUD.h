//
//  BLoadingHUD.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BBaseHUD.h"

extern const NSTimeInterval BLoadingHUDMaxInterval;

@interface BLoadingHUD : BBaseHUD

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

@end
