//
//  BViewController.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 29/1/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BHUD.h"
#import "BNavigationInteractiveProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^BViewControllerHUDBlock)(void);

typedef NS_OPTIONS(NSInteger, BViewControllerLifeCycle)
{
    BViewControllerLifeCycleFirstViewWillAppear        = 1 << 0,
    BViewControllerLifeCycleFirstViewDidAppear         = 1 << 1,
    BViewControllerLifeCycleFirstViewWillLayoutSubview = 1 << 2,
    BViewControllerLifeCycleFirstViewDidLayoutSubview  = 1 << 3,
    BViewControllerLifeCycleFirstViewWillDisappear     = 1 << 4,
    BViewControllerLifeCycleFirstViewDidDisappear      = 1 << 5,
};

@interface BViewController : UIViewController <BNavigationInteractivePopProtocol>

@property (nonatomic, assign, readonly) BViewControllerLifeCycle lifeCycle;

- (void)adjustScrollViewInset:(UIScrollView *)scrollView;
- (void)automaticallyAdjustsScrollViewInsetsForKeyboardChange:(UIScrollView *)scrollView
                                       usingBottomLayoutGuide:(BOOL)usingBottomLayoutGuide;

#pragma mark - Subclass
/** 
 If returned YES,
 Navigation bar will automatically be hidden when view controller moves to the top of navigation stack.
 Navigation bar will automatically be shown when view controller move from the top of navigation stack.
 *** Only works with BNavigationController.
 Defaults to NO.
 */
- (BOOL)automaticallyHidesNavigationBar;

- (BOOL)hidesBackButton;

/** Called when back button on navigation bar is tapped. Defaults to pop view controller. */
- (void)didTapBackButton:(id)sender;

- (void)disablesBackBarButton;

- (void)enablesBackBarButton;

@end

NS_ASSUME_NONNULL_END
