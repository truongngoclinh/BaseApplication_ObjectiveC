//
//  UIViewController+MBProgressHUD.h
//  BTFoundation
//
//  Created by garena on 4/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface UIViewController (MBProgressHUD)

/*
Configuration
*/

/**
Configure default loading message for all HUD instances.
Note that when language is changed, you might want to call this again to load the message in the correct language.
*/
+ (void)bt_configureHUDLoadingMessage:(NSString *)defaultLoadingMessage;
+ (NSString *)bt_defaultHUDLoadingMessage;

// HUDs
- (MBProgressHUD *)bt_hudShowLoadingInView;
- (MBProgressHUD *)bt_hudShowLoadingInWindow;
- (MBProgressHUD *)bt_hudShowInViewText:(NSString*)text;
- (MBProgressHUD *)bt_hudShowSuccessDetailedInView:(NSString *)successMessage;
- (MBProgressHUD *)bt_hudShowSuccessInView:(NSString *)successMessage;
- (MBProgressHUD *)bt_hudShowSuccessInWindow:(NSString *)successMessage;
- (MBProgressHUD *)bt_hudShowErrorInView:(NSString *)errorMessage;
- (MBProgressHUD *)bt_hudShowErrorDetailedInView:(NSString *)errorMessage;
- (MBProgressHUD *)bt_hudShowErrorInWindow:(NSString *)errorMessage;
- (BOOL)bt_hudHideInView;
- (BOOL)bt_hudHideInWindow;

@end
