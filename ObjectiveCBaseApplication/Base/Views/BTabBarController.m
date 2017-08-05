//
//  BTabBarController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 29/1/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BTabBarController.h"

//#import "BAnalytics.h"

static CGFloat const kBTabBarControllerAccountPageIndex = 0;
static CGFloat const kBTabBarControllerSellPageIndex = 1;

BLogLevel(BLogLevelInfo)

NSString *const BTabBarControllerSelectedNotification = @"BTabBarControllerSelectedNotification";

@interface BTabBarController () <UITabBarControllerDelegate>

@end

@implementation BTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"element_toolbar_bg"];
    self.tabBar.shadowImage = [[UIImage alloc] init];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSBackgroundColorAttributeName:[BTheme textColor]}
                                             forState:UIControlStateSelected];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    // Event tracking
    NSUInteger originalIndex = self.selectedIndex;
    NSUInteger newIndex = [self.viewControllers indexOfObject:viewController];
    if (originalIndex == kBTabBarControllerAccountPageIndex &&
        newIndex == kBTabBarControllerSellPageIndex) {
        
//        [[BAnalytics sharedInstance] trackEventWithCategory:B_ANALYTICS_EVENT_CATEGORY_PRODUCTS
//                                                      action:B_ANALYTICS_EVENT_ACTION_CLICK_SELL_TAB_BUTTON
//                                                       label:nil
//                                                       value:nil];
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BTabBarControllerSelectedNotification
                                                        object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.selectedViewController preferredStatusBarStyle];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - BTraverseProtocol

- (BOOL)canTraverse:(BTraverseItem *)traverseItem
{
    __block BOOL canTraverse = NO;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        
        if ([vc conformsToProtocol:@protocol(BTraverseProtocol)] &&
            [(id<BTraverseProtocol>)vc canTraverse:traverseItem]) {
            
            canTraverse = YES;
            *stop = NO;
        }
    }];
    
    return canTraverse;
}

- (void)traverse:(BTraverseItem *)traverseItem
{
    DDLogInfo(@"[%@] traverse: %@", self.class, traverseItem);
    
    __block UIViewController<BTraverseProtocol> *traverseVC = nil;
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        
        if ([vc conformsToProtocol:@protocol(BTraverseProtocol)] &&
            [(id<BTraverseProtocol>)vc canTraverse:traverseItem]) {
            
            traverseVC = (id)vc;
            *stop = NO;
        }
    }];
    
    if (!traverseVC) {
        NSParameterAssert(NO);
        return;
    }
    
    BWeakify(self, me);
    void(^traverseBlock)(void) = ^{
        
        UINavigationController *nvc = (id)self.selectedViewController;
        
        // Current tab is already the VC
        if (self.selectedViewController == traverseVC) {
            
            [traverseVC traverse:traverseItem];
        }
        // Pop existing VC in the navigation stack
        else if ([nvc isKindOfClass:[UINavigationController class]] &&
                 nvc.viewControllers.count > 1) {
            
            DDLogInfo(@"[%@] traverse popping current VC stack:%@", self.class, @(nvc.viewControllers.count));
            
            [nvc popToRootViewControllerAnimated:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                me.selectedViewController = traverseVC;
                [traverseVC traverse:traverseItem];
            });
        }
        // Change tab
        else {
            me.selectedViewController = traverseVC;
            [traverseVC traverse:traverseItem];
        }
    };
    
    // Dismiss any presented view controllers
    if (self.presentedViewController) {
        DDLogInfo(@"[%@] traverse dismissing presented VC", self.class);
        [self dismissViewControllerAnimated:NO completion:traverseBlock];
    } else {
        traverseBlock();
    }
}

@end
