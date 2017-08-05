//
//  BNavigationController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 29/1/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BNavigationController.h"

BLogLevel(BLogLevelOff);

@interface BNavigationController () <UINavigationControllerDelegate>

@end

@implementation BNavigationController

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        __weak UINavigationController<UINavigationControllerDelegate> *weakSelf = self;
        self.delegate = weakSelf;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Swipe-to-go-back: Step 1
    //!!!Tricky: This is to make the "Swipe-to-go-back" work.
    //Since we use leftBarButton instead of backBarButton, the swipe-to-go-back gesture on iOS 7
    //does not work unless we do the following.
    BWeakify(self, weakSelf);
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)weakSelf;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = (self.viewControllers.count != 0);
    [super pushViewController:viewController animated:animated];
    
    //Swipe-to-go-back: Step 2
    //Disable this to avoid crash.
    [self disableInteractiveTransition];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.hidesBottomBarWhenPushed = (idx != 0);
    }];
    
    [super setViewControllers:viewControllers animated:animated];
    
    //Swipe-to-go-back: Step 2
    //Disable this to avoid crash.
    [self disableInteractiveTransition];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (animated) {
        return [super popToRootViewControllerAnimated:animated];
    }
    
    // Hack: Instead of calling popToRootViewController, we pop the view controllers in this manner
    // This to fix a bug in iOS8 where in some cases the UITabbar will not be shown, and there is
    // a black placeholder there instead.
    NSMutableArray<UIViewController *> *poppedViewControllers = [NSMutableArray array];
    [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:
     ^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
         if (idx != 0) {
             [poppedViewControllers insertObject:vc atIndex:0];
             [vc.navigationController popViewControllerAnimated:NO];
         }
    }];
    
    return [poppedViewControllers copy];
}

#pragma mark - Intractive Transition

- (void)disableInteractiveTransition
{
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)enableInteractiveTransition
{
    self.interactivePopGestureRecognizer.enabled = (self.viewControllers.count > 1);
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.topViewController preferredStatusBarStyle];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([viewController conformsToProtocol:@protocol(BNavigationControllerEvents)] &&
        [viewController respondsToSelector:@selector(navigationController:willShowViewControllerAnimated:)]) {
        [(id<BNavigationControllerEvents>)viewController navigationController:self
                                                willShowViewControllerAnimated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    //Swipe-to-go-back: Step 3
    // Enable the gesture again once the new controller is shown
    //Tricky: This condition is crucial. If don't do this, then the app will freeze after the user has attempted to
    //swipe-to-go-back at the root screen.
    [self enableInteractiveTransition];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) {
        NSParameterAssert(NO);
        return NO;
    }
    
    UIViewController *vc = [self.viewControllers lastObject];
    BOOL supportsInteractivePop = YES;
    BNavigationInteractivePopOption option = 0;
    
    if ([vc conformsToProtocol:@protocol(BNavigationInteractivePopProtocol)]) {
        id<BNavigationInteractivePopProtocol> protoVC = (id)vc;
        
        supportsInteractivePop = [protoVC supportsInteractivePop];
        
        if ([protoVC respondsToSelector:@selector(interactivePopOption)]) {
            option = [protoVC interactivePopOption];
        }
    }
    
    BOOL navigationBarCheck = (option & BNavigationInteractivePopOptionEnableEvenWhenNavigationBarHidden ||
                               !self.navigationBar.hidden);
    BOOL leftButtonCheck = (option & BNavigationInteractivePopOptionEnableEvenWhenLeftButtonDisabled ||
                            vc.navigationItem.leftBarButtonItem.enabled ||
                            vc.navigationItem.backBarButtonItem.enabled);

    DDLogVerbose(@"[%@] supportsInteractivePop: %d, navigationBarCheck: %d, leftButtonCheck: %d",
                 self.class, supportsInteractivePop, navigationBarCheck, leftButtonCheck);
    return supportsInteractivePop && navigationBarCheck && leftButtonCheck;
}

#pragma mark - BTraverseProtocol

- (BOOL)canTraverse:(BTraverseItem *)traverseItem
{
    NSParameterAssert(self.viewControllers.count);
    UIViewController *viewController = self.viewControllers[0];

    return ([viewController conformsToProtocol:@protocol(BTraverseProtocol)] &&
            [(id<BTraverseProtocol>)viewController canTraverse:traverseItem]);
}

- (void)traverse:(BTraverseItem *)traverseItem
{
    NSParameterAssert(self.viewControllers.count);
    
    UIViewController *viewController = self.viewControllers[0];
    
    if ([viewController conformsToProtocol:@protocol(BTraverseProtocol)]) {
        [(id<BTraverseProtocol>)viewController traverse:traverseItem];
    }
}

@end
