//
//  UIViewController+BNavigation.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIViewController (BNavigation)

- (UINavigationController *)b_embedInNavigationController;
- (UINavigationController *)b_embedInLoginNavigationController;

@end
