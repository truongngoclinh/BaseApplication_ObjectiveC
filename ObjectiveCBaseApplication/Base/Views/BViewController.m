//
//  BViewController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 29/1/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BViewController.h"
#import "BNavigationController.h"
//#import "BCrashReportingService.h"
#import "BTKeyboardNotifier.h"
#import "BUIService.h"
#import "BBarButtonItem.h"

BLogLevel(BLogLevelInfo)

#define BVC_CRASH_LOG_LC()             [[BCrashReportingService sharedInstance] logObject:self forKey:NSStringFromSelector(_cmd)]
#define BVC_LOG_LC()                   DDLogVCLifeCycle(@"**%@:%@", NSStringFromSelector(_cmd), self)
#define BVC_LOG_LC_ANIMATED(animated)  DDLogVCLifeCycle(@"**%@(%d):%@", NSStringFromSelector(_cmd), (animated), self)

@interface BKeyboardNotifierItem : NSObject
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL usingBottomLayoutGuide;
@end
@implementation BKeyboardNotifierItem
@end

@interface BViewController () <BTKeyboardNotifier, BNavigationControllerEvents>

@property (nonatomic, strong) BKeyboardNotifierItem *keyboardNotifierItem;
@property (nonatomic, strong) BBaseHUD *hud;

@property (nonatomic, assign) BViewControllerLifeCycle happenedLifeCycle;
@property (nonatomic, assign) BViewControllerLifeCycle lifeCycle;

@property (nonatomic, assign) UIViewController *viewControllerOnTop;

@end

@implementation BViewController

- (void)dealloc
{
    BVC_LOG_LC();
//    BVC_CRASH_LOG_LC();
    DDLogInfo(@"[%@] dealloc", self.class);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    BVC_LOG_LC();
//    BVC_CRASH_LOG_LC();
    
    if ([self hidesBackButton]) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        [self customizeBackButton];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateLifeCycle:BViewControllerLifeCycleFirstViewWillAppear];
    
    BVC_LOG_LC_ANIMATED(animated);
//    BVC_CRASH_LOG_LC();
    
    // Fixed issue with wrong content inset when becoming first responder in viewWillAppear.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8") && self.keyboardNotifierItem) {
        [self.view layoutIfNeeded];
    }

    [[BUIService sharedInstance] animatingViewController:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateLifeCycle:BViewControllerLifeCycleFirstViewDidAppear];
    
    BVC_LOG_LC_ANIMATED(animated);
//    BVC_CRASH_LOG_LC();
    
    [[BUIService sharedInstance] animatedViewController:self];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self updateLifeCycle:BViewControllerLifeCycleFirstViewWillLayoutSubview];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self updateLifeCycle:BViewControllerLifeCycleFirstViewDidLayoutSubview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self updateLifeCycle:BViewControllerLifeCycleFirstViewWillDisappear];
    
    BVC_LOG_LC_ANIMATED(animated);
//    BVC_CRASH_LOG_LC();
    
    [[BUIService sharedInstance] animatingViewController:self];
    
    // If a new vc of other classes is being pushed
    // Restore its default bar status (i.e. not hidden) if needed
    id lastObject = [self.navigationController.viewControllers lastObject];
    if (lastObject != self &&
        ![lastObject isKindOfClass:[BViewController class]] &&
        self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self updateLifeCycle:BViewControllerLifeCycleFirstViewDidDisappear];
    
    BVC_LOG_LC_ANIMATED(animated);
//    BVC_CRASH_LOG_LC();
    
    [[BUIService sharedInstance] animatedViewController:self];
}

- (void)adjustScrollViewInset:(UIScrollView *)scrollView
{
    UIEdgeInsets inset = scrollView.contentInset;
    inset.top = MAX([self.topLayoutGuide length],  inset.top);
    inset.bottom = MAX([self.bottomLayoutGuide length], inset.bottom);
    scrollView.contentInset = inset;
    scrollView.scrollIndicatorInsets = inset;
}

- (void)automaticallyAdjustsScrollViewInsetsForKeyboardChange:(UIScrollView *)scrollView usingBottomLayoutGuide:(BOOL)usingBottomLayoutGuide
{
    if (!self.keyboardNotifierItem) {
        self.keyboardNotifierItem = [[BKeyboardNotifierItem alloc] init];
        self.keyboardNotifierItem.scrollView = scrollView;
        self.keyboardNotifierItem.usingBottomLayoutGuide = usingBottomLayoutGuide;
        [[BTKeyboardNotifier sharedInstance] addDelegate:self];
    } else {
        NSAssert(NO, @"Only supports one scrollView!");
    }
}

- (BOOL)automaticallyHidesNavigationBar
{
    return NO;
}

- (void)updateLifeCycle:(BViewControllerLifeCycle)lifeCycle
{
    // Check if a particular life cycle has happened before
    BOOL happened = (self.happenedLifeCycle & lifeCycle) != 0;
    
    // If it has not happened, then it is happening now
    self.lifeCycle = happened ? 0 : lifeCycle;
    
    // Mark it as happened
    self.happenedLifeCycle |= lifeCycle;
}

#pragma mark - Navigation

- (void)customizeBackButton
{
    if ([self hasPreviousPage]) {
        UIBarButtonItem *item = [BBarButtonItem backBarButtonItemTitle:@""
                                                               selector:@selector(didTapBackButton:)
                                                                 target:self];
        self.navigationItem.leftBarButtonItem = item;
        //Note: Using leftBarButtonItem in the place of backBarButtonItem will break the
        //swipe-to-go-back gesture on iOS7. So we use a hack to solve it. For details,
        //refer to [BPNavigationController viewDidAppear].
    }
}

- (BOOL)hidesBackButton
{
    return NO;
}

- (BOOL)hasPreviousPage
{
    return ([self.navigationController.viewControllers count] > 1);
}

- (void)didTapBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)disablesBackBarButton
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)enablesBackBarButton
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

#pragma mark BNavigationInteractivePopProtocol

- (BOOL)supportsInteractivePop
{
    return YES;
}

#pragma mark - BTKeyboardNotifier

- (void)keyboardWillShowWithRect:(CGRect)rect duration:(CGFloat)duration animationOptions:(UIViewAnimationOptions)animationOptions
{
    NSParameterAssert(self.keyboardNotifierItem);
    
    // Convert keyboard rect to scrollView's coordinate
    CGRect rectInView = [self.keyboardNotifierItem.scrollView convertRect:rect fromView:nil];
    CGFloat heightDifference = CGRectGetMaxY(self.keyboardNotifierItem.scrollView.bounds) - CGRectGetMinY(rectInView);
    
    if (heightDifference <= 0)
        return;
    
    UIEdgeInsets inset = self.keyboardNotifierItem.scrollView.contentInset;
    inset.bottom = heightDifference;
    UIEdgeInsets scrollInset = self.keyboardNotifierItem.scrollView.scrollIndicatorInsets;
    scrollInset.bottom = heightDifference;
    
    [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
        self.keyboardNotifierItem.scrollView.contentInset = inset;
        self.keyboardNotifierItem.scrollView.scrollIndicatorInsets = scrollInset;
    } completion:nil];
}

- (void)keyboardWillHideWithRect:(CGRect)rect duration:(CGFloat)duration animationOptions:(UIViewAnimationOptions)animationOptions
{
    NSParameterAssert(self.keyboardNotifierItem);
    CGFloat bottomInset = self.keyboardNotifierItem.usingBottomLayoutGuide ? [self.bottomLayoutGuide length] : 0;
    
    UIEdgeInsets inset = self.keyboardNotifierItem.scrollView.contentInset;
    inset.bottom = bottomInset;
    UIEdgeInsets scrollInset = self.keyboardNotifierItem.scrollView.scrollIndicatorInsets;
    scrollInset.bottom = bottomInset;;
    
    [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
        self.keyboardNotifierItem.scrollView.contentInset = inset;
        self.keyboardNotifierItem.scrollView.scrollIndicatorInsets = scrollInset;
    } completion:nil];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - BNavigationControllerEvents

- (void)navigationController:(BNavigationController *)navigationController willShowViewControllerAnimated:(BOOL)animated
{
    if (self.navigationController.navigationBarHidden != [self automaticallyHidesNavigationBar]) {
        [self.navigationController setNavigationBarHidden:[self automaticallyHidesNavigationBar] animated:animated];
    }
}

#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
