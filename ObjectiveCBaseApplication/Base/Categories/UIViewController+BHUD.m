//
//  UIViewController+BHUD.m
//  Cyberpay
//
//  Created by Andrew Eng on 3/9/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "UIViewController+BHUD.h"
#import <objc/runtime.h>

static char BHUDIdentifier;

@interface UIViewController ()

@property (nonatomic, strong) BBaseHUD *b_HUD;

@end

@implementation UIViewController (BHUD)

- (void)b_HUDHide
{
    [self.b_HUD hide];
}

#pragma mark - Accessors

- (BOOL)b_isHUDShowing
{
    return self.b_HUD.isShowing;
}

- (void)setCp_HUD:(BBaseHUD *)b_HUD
{
    objc_setAssociatedObject(self, &BHUDIdentifier, b_HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BBaseHUD *)b_HUD
{
    return objc_getAssociatedObject(self, &BHUDIdentifier);
}

#pragma mark - Loading HUD

- (void)b_HUDShowLoading
{
    [self b_HUDShowLoadingText:nil];
}

- (void)b_HUDShowLoadingInView:(UIView *)view
{
    [self b_HUDShowLoadingText:nil inView:view];
}

- (void)b_HUDShowLoadingInView:(UIView *)view duration:(NSTimeInterval)duration
{
    [self b_HUDShowLoadingText:nil inView:view duration:duration];
}

- (void)b_HUDShowLoadingText:(NSString *)text
{
    [self b_HUDShowLoadingText:text inView:self.view];
}

- (void)b_HUDShowLoadingText:(NSString *)text inView:(UIView *)view
{
    [self b_HUDShowLoadingText:text inView:view duration:BLoadingHUDMaxInterval];
}

- (void)b_HUDShowLoadingText:(NSString *)text inView:(UIView *)view duration:(NSTimeInterval)duration
{
    BLoadingHUD *HUD = [[BLoadingHUD alloc] initWithFrame:CGRectZero text:text];
    [self b_HUD:HUD showInView:view duration:duration completion:nil];
}

#pragma mark - Success HUD

- (void)b_HUDShowSuccessText:(NSString *)text
{
    [self b_HUDShowSuccessText:text completion:nil];
}

- (void)b_HUDShowSuccessText:(NSString *)text completion:(BHUDCompletion)completion
{
    [self b_HUDShowSuccessText:text inView:self.view completion:completion];
}

- (void)b_HUDShowSuccessText:(NSString *)text inView:(UIView *)view
{
    [self b_HUDShowSuccessText:text inView:view completion:nil];
}

- (void)b_HUDShowSuccessText:(NSString *)text inView:(UIView *)view completion:(BHUDCompletion)completion
{
    NSTimeInterval duration = [BSuccessHUD durationForText:text];
    [self b_HUDShowSuccessText:text inView:view duration:duration completion:completion];
}

- (void)b_HUDShowSuccessText:(NSString *)text
                       inView:(UIView *)view
                     duration:(NSTimeInterval)duration
                   completion:(BHUDCompletion)completion
{
    if (!text) {
        NSParameterAssert(NO);
        return;
    }
    
    BSuccessHUD *HUD = [[BSuccessHUD alloc] initWithFrame:CGRectZero];
    HUD.text = text;
    [self b_HUD:HUD showInView:view duration:duration completion:completion];
}

#pragma mark - Error HUD

- (void)b_HUDShowErrorText:(NSString *)text
{
    [self b_HUDShowErrorText:text completion:nil];
}

- (void)b_HUDShowErrorText:(NSString *)text inView:(UIView *)view
{
    [self b_HUDShowErrorText:text inView:view completion:nil];
}

- (void)b_HUDShowErrorText:(NSString *)text completion:(BHUDCompletion)completion
{
    [self b_HUDShowErrorText:text inView:self.view completion:completion];
}

- (void)b_HUDShowErrorText:(NSString *)text inView:(UIView *)view completion:(BHUDCompletion)completion
{
    NSTimeInterval duration = [BErrorHUD durationForText:text];
    [self b_HUDShowErrorText:text inView:view duration:duration completion:completion];
}

- (void)b_HUDShowErrorText:(NSString *)text
                     inView:(UIView *)view
                   duration:(NSTimeInterval)duration
                 completion:(BHUDCompletion)completion
{
    if (!text) {
        NSParameterAssert(NO);
        return;
    }
    
    BErrorHUD *HUD = [[BErrorHUD alloc] initWithFrame:CGRectZero];
    HUD.text = text;
    [self b_HUD:HUD showInView:view duration:duration completion:completion];
}

#pragma mark Custom

- (void)b_HUD:(BBaseHUD *)HUD
    showInView:(UIView *)view
      duration:(NSTimeInterval)duration
    completion:(void (^)(void))completion
{
    if (!HUD || !view) {
        NSParameterAssert(NO);
        return;
    }
    
    [self.b_HUD hide];
    [HUD showInView:view duration:duration completion:completion];
    self.b_HUD = HUD;
}

@end
