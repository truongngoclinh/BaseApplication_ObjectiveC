//
//  UIViewController+MBProgressHUD.m
//  BTFoundation
//
//  Created by garena on 4/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"
#import "MBProgressHUD+BTFoundation.h"

static NSString *kBTDefautLoadingMessage = @"Loading";

@implementation UIViewController (MBProgressHUD)

+ (void)bt_configureHUDLoadingMessage:(NSString *)defaultLoadingMessage
{
    kBTDefautLoadingMessage = defaultLoadingMessage;
}

+ (NSString *)bt_defaultHUDLoadingMessage
{
    return kBTDefautLoadingMessage;
}

// HUDs
- (MBProgressHUD *)bt_hudShowLoadingInView
{
   return [MBProgressHUD bt_showLoadingHUD:kBTDefautLoadingMessage inView:self.view];
}

- (MBProgressHUD *)bt_hudShowLoadingInWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [MBProgressHUD bt_showLoadingHUD:kBTDefautLoadingMessage inView:keyWindow];
}

- (MBProgressHUD *)bt_hudShowInViewText:(NSString*)text
{
    return [MBProgressHUD bt_showLoadingHUD:text inView:self.view];
}

- (MBProgressHUD *)bt_hudShowSuccessDetailedInView:(NSString *)successMessage
{
    return [MBProgressHUD bt_showSuccessHUD:nil detailText:successMessage inView:self.view];
}

- (MBProgressHUD *)bt_hudShowSuccessInView:(NSString *)successMessage
{
    return [MBProgressHUD bt_showSuccessHUD:successMessage inView:self.view];
}

- (MBProgressHUD *)bt_hudShowSuccessInWindow:(NSString *)successMessage
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [MBProgressHUD bt_showSuccessHUD:successMessage inView:keyWindow];
}

- (MBProgressHUD *)bt_hudShowErrorInView:(NSString *)errorMessage
{
    return [MBProgressHUD bt_showErrorHUD:errorMessage inView:self.view];
}

- (MBProgressHUD *)bt_hudShowErrorDetailedInView:(NSString *)errorMessage
{
    return [MBProgressHUD bt_showErrorHUD:nil detailText:errorMessage inView:self.view];
}

- (MBProgressHUD *)bt_hudShowErrorInWindow:(NSString *)errorMessage
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [MBProgressHUD bt_showErrorHUD:errorMessage inView:keyWindow];
}

- (BOOL)bt_hudHideInView
{
    return [MBProgressHUD bt_dismissHUDInView:self.view];
}

- (BOOL)bt_hudHideInWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [MBProgressHUD bt_dismissHUDInView:keyWindow];
}

@end
