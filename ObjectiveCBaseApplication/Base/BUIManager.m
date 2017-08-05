//
//  BUIManager.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 23/2/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "BUIManager.h"
#import "UIViewController+BNavigation.h"

//#import "BLoginViewController.h"
//
#import "BTabBarController.h"
//#import "BAccountViewController.h"
//#import "BSellViewController.h"
//#import "BActivityViewController.h"
//#import "BMeViewController.h"

#import "BUIService.h"
#import "BUIServiceRoot.h"

@interface BUIManager ()

@property (nonatomic, strong) BUIService *UIService;

@end

@implementation BUIManager

- (instancetype)initWithUIService:(BUIService *)UIService
{
    self = [super init];
    if (self) {
        NSParameterAssert(UIService);
        _UIService = UIService;
    }
    return self;
}

- (void)showLoginRootViewController
{
//    BLoginViewController *loginVC = [[BLoginViewController alloc] initWithNibName:nil bundle:nil];
//    [self.UIService replaceRootViewController:[loginVC b_embedInLoginNavigationController]];
}

- (void)showRootViewController
{
    UIViewController *rootViewController = [BUIManager rootViewControllerWithOption:0];
    [self.UIService replaceRootViewController:rootViewController];
}

- (void)reloadRootViewControllerWithOption:(BUIManagerRootVCOption)option
{
    UIViewController *rootViewController = [BUIManager rootViewControllerWithOption:option];
    [self.UIService replaceRootViewController:rootViewController];
}

#pragma mark - Root View Controller

+ (UIViewController *)rootViewControllerWithOption:(BUIManagerRootVCOption)option
{
    NSMutableArray *vcs = [NSMutableArray array];

//    // Account
//    BAccountViewController *accountVC = [[BAccountViewController alloc] initWithNibName:nil bundle:nil];
//    [vcs addObject:[accountVC b_embedInNavigationController]];
//    
//    // Sell
//    BSellViewController *sellVC = [[BSellViewController alloc] initWithNibName:nil bundle:nil];
//    [vcs addObject:[sellVC b_embedInNavigationController]];
//    
//    // Activity
//    BActivityViewController *reportVC = [[BActivityViewController alloc] initWithNibName:nil bundle:nil];
//    [vcs addObject:[reportVC b_embedInNavigationController]];
//    
//    // Me
//    BMeViewController *meVC = [[BMeViewController alloc] initWithNibName:nil bundle:nil];
//    [vcs addObject:[meVC b_embedInNavigationController]];
//    
    // Tab bar
    BTabBarController *tabVC = [[BTabBarController alloc] initWithNibName:nil bundle:nil];
    tabVC.viewControllers = [vcs copy];
    
//    if (option == BUIManagerRootVCOptionDefaultTabMe) {
//        tabVC.selectedViewController = meVC.navigationController;
//    }
//    
//    [accountVC setupTabBarBadge];
//    
    return tabVC;
}

#pragma mark - Navigate

- (void)traverse:(BTraverseItem *)traverseItem
{
    UIViewController<BTraverseProtocol> *vc = (id)[BUIService sharedInstance].window.rootViewController;
    
    if (![vc conformsToProtocol:@protocol(BTraverseProtocol)]) {
        NSParameterAssert(NO);
        return;
    }

    if (![vc canTraverse:traverseItem]) {
        NSParameterAssert(NO);
        return;
    }
    
    [vc traverse:traverseItem];
}

@end
