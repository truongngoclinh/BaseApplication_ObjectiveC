//
//  UIViewController+BNavigation.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "UIViewController+BNavigation.h"

#import "BNavigationController.h"
#import "BNavigationBar.h"
#import "BLoginNavigationController.h"

@implementation UIViewController (BNavigation)

- (UINavigationController *)b_embedInNavigationController
{
    BNavigationController *navigationController = [[BNavigationController alloc] initWithNavigationBarClass:[BNavigationBar class]
                                                                                                 toolbarClass:nil];
    [navigationController pushViewController:self animated:NO];
    return navigationController;
}

- (UINavigationController *)b_embedInLoginNavigationController
{
    BLoginNavigationController *navigationController = [[BLoginNavigationController alloc] initWithNavigationBarClass:[BNavigationBar class]
                                                                                                 toolbarClass:nil];
    [navigationController pushViewController:self animated:NO];
    return navigationController;
}

@end
