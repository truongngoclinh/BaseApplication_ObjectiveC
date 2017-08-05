//
//  UIViewController+BHUD.h
//  Cyberpay
//
//  Created by Andrew Eng on 3/9/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLoadingHUD.h"
#import "BSuccessHUD.h"
#import "BErrorHUD.h"

@interface UIViewController (BHUD)

@property (nonatomic, assign, readonly) BOOL b_isHUDShowing;

- (void)b_HUDHide;

#pragma mark Loading HUD

- (void)b_HUDShowLoading;
- (void)b_HUDShowLoadingInView:(UIView *)view;
- (void)b_HUDShowLoadingInView:(UIView *)view duration:(NSTimeInterval)duration;

- (void)b_HUDShowLoadingText:(NSString *)text;
- (void)b_HUDShowLoadingText:(NSString *)text inView:(UIView *)view;
- (void)b_HUDShowLoadingText:(NSString *)text inView:(UIView *)view duration:(NSTimeInterval)duration;

#pragma mark Success HUD

- (void)b_HUDShowSuccessText:(NSString *)text;
- (void)b_HUDShowSuccessText:(NSString *)text completion:(BHUDCompletion)completion;
- (void)b_HUDShowSuccessText:(NSString *)text inView:(UIView *)view;
- (void)b_HUDShowSuccessText:(NSString *)text inView:(UIView *)view completion:(BHUDCompletion)completion;
- (void)b_HUDShowSuccessText:(NSString *)text
                       inView:(UIView *)view
                     duration:(NSTimeInterval)duration
                   completion:(BHUDCompletion)completion;

#pragma mark Error HUD

- (void)b_HUDShowErrorText:(NSString *)text;
- (void)b_HUDShowErrorText:(NSString *)text completion:(BHUDCompletion)completion;
- (void)b_HUDShowErrorText:(NSString *)text inView:(UIView *)view;
- (void)b_HUDShowErrorText:(NSString *)text inView:(UIView *)view completion:(BHUDCompletion)completion;

#pragma mark Custom HUD

- (void)b_HUD:(BBaseHUD *)HUD
    showInView:(UIView *)view
      duration:(NSTimeInterval)duration
    completion:(BHUDCompletion)completion;

@end
