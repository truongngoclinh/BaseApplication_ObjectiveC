//
//  BUIService.h
//  Cyberpay
//
//  Created by Linh on 25/2/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUIService : NSObject

@property (nonatomic, strong) UIWindow *window;

+ (instancetype)sharedInstance;

- (void)animatingViewController:(UIViewController *)viewController;
- (void)animatedViewController:(UIViewController *)viewController;

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

@end
