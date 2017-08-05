//
//  MBProgressHUD+BTAdditions.h
//  BTFoundation
//
//  Created by garena on 30/10/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "MBProgressHUD.h"

@protocol MBProgressHUDAnimatedView <NSObject>
- (void)startAnimation;
@end

@interface MBProgressHUD (BTFoundation)

/*
Configuration
*/

/**
Use this to configure the default timeout for all HUD instances.
Default is 180s
*/
+ (void)bt_configureDefaultTimeout:(NSTimeInterval)timeout;
+ (NSTimeInterval)bt_defaultTimeout;

/**
 Use this to configure the default hideDelay for all HUD instances
 */
+ (void)bt_configureDefaultHideDelay:(NSTimeInterval)hideDelay;
+ (NSTimeInterval)bt_defaultHideDelay;

/**
Configure min size of hud for all HUD instances
*/
+ (void)bt_configureMinSize:(CGSize)size;
+ (CGSize)bt_minSize;

/**
 Configure margin from hud edge to the content
 */
+ (void)bt_configureMargin:(CGFloat)margin;
+ (CGFloat)bt_margin;

/**
 Configure corner radius of hud
 */
+ (void)bt_configureCornerRadius:(CGFloat)cornerRadius;
+ (CGFloat)bt_cornerRadius;

/**
 Configure main label
 */
+ (void)bt_configureMainLabelFont:(UIFont *)font;
+ (void)bt_configureMainLabelTextColor:(UIColor *)color;
+ (UIColor *)bt_mainLabelColor;
+ (UIFont *)bt_mainLabelFont;

/**
 Configure detail label
 */
+ (void)bt_configureDetailLabelFont:(UIFont *)font;
+ (void)bt_configureDetailLabelTextColor:(UIColor *)color;
+ (UIColor *)bt_detailLabelColor;
+ (UIFont *)bt_detailLabelFont;

/**
 Configure image used for error/success hud.
 Has no effect if customSuccesssView or customErrorView is set
 */
+ (void)bt_configureSuccessImageName:(NSString *)imgName;
+ (void)bt_configureErrorImageName:(NSString *)imgName;
+ (NSString *)bt_successImageName;
+ (NSString *)bt_errorImageName;

/**
 Configure view used for error/success/loading hud.
 */
+ (void)bt_configureSuccessCustomView:(UIView *)view;
+ (void)bt_configureErrorCustomView:(UIView *)view;
+ (UIView *)bt_successCustomView;
+ (UIView *)bt_errorCustomView;

+ (void)bt_configureLoadingCustomView:(UIView *)view;
+ (UIView *)bt_loadingCustomView;

+ (void)bt_configureLoadingCustomAnimationView:(UIView<MBProgressHUDAnimatedView> *)view;
+ (UIView *)bt_loadingCustomAnimationView;

/*
Display 
*/
+ (instancetype)bt_showLoadingHUDInWindow;
+ (instancetype)bt_showLoadingHUDInView:(UIView *)view;
+ (instancetype)bt_showLoadingHUD:(NSString *)text inView:(UIView *)view;
+ (instancetype)bt_showLoadingHUD:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (instancetype)bt_showProgressLoadingHUDInView:(UIView*)view;

+ (instancetype)bt_showSuccessHUD:(NSString *)text inView:(UIView *)view;
+ (instancetype)bt_showSuccessHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view;

+ (instancetype)bt_showErrorHUD:(NSString *)text inView:(UIView *)view;
+ (instancetype)bt_showErrorHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view;
+ (instancetype)bt_showErrorHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view delay:(NSTimeInterval)delay;
+ (BOOL)bt_dismissHUDInView:(UIView *)view;
+ (BOOL)bt_dismissHUDInWindow;

@end
