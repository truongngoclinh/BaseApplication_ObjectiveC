//
//  BUIService.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 25/2/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "BUIService.h"
#import "BUIServiceAnimationTracker.h"
#import "BUIServiceRoot.h"

typedef void(^BUIServicePresentationBlock)(void);

@interface BUIService ()

@property (nonatomic, strong) BUIServiceAnimationTracker *animationTracker;

@end

@implementation BUIService

+ (instancetype)sharedInstance
{
    static BUIService *UIService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIService = [[self alloc] init];
    });
    return UIService;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animationTracker = [[BUIServiceAnimationTracker alloc] init];
    }
    return self;
}

- (void)animatingViewController:(UIViewController *)viewController
{
    [self.animationTracker animatingObject:viewController];
}

- (void)animatedViewController:(UIViewController *)viewController
{
    [self.animationTracker animatedObject:viewController];
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *viewControllerToPresentOn = [self frontMostPresentedViewController];
    
    BUIServicePresentationBlock block = ^{
        [viewControllerToPresentOn presentViewController:viewController animated:animated completion:completion];
    };
    
    [self.animationTracker executeBlockAfterAnimation:block];
}

- (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [viewController dismissViewControllerAnimated:animated completion:completion];
}

- (UIViewController *)frontMostPresentedViewController
{
    UIViewController *viewController = self.window.rootViewController;
    
    while (viewController.presentedViewController != nil) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController;
}

#pragma mark - Root

- (UIViewController *)rootViewController
{
    return self.window.rootViewController;
}

- (void)replaceRootViewController:(UIViewController *)rootViewController
{
    if (self.window.rootViewController) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromBottom;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.window.layer addAnimation:transition forKey:kCATransition];
    }
    
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
}

@end
