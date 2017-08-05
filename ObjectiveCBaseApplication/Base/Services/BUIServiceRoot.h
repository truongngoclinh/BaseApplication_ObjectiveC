//
//  BUIServiceRoot.h
//  Cyberpay
//
//  Created by Linh on 30/6/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#ifndef Cyberpay_BUIServiceRoot_h
#define Cyberpay_BUIServiceRoot_h

@interface BUIService ()

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

- (void)replaceRootViewController:(UIViewController *)rootViewController;

@end

#endif
