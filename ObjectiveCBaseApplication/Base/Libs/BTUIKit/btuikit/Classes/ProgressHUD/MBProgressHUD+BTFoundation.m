//
//  MBProgressHUD+BTAdditions.m
//  BTFoundation
//
//  Created by garena on 30/10/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "MBProgressHUD+BTFoundation.h"
#import "NSString+BTSize.h"

static NSTimeInterval kLoadingTimeout = 180;
static NSTimeInterval kHideDelay = 1.3;
static CGFloat kMinSizeWidth = 100;
static CGFloat kMinSizeHeight = 100;
static CGFloat kMargin = 20;
static CGFloat kCornerRadius = 10;

static UIFont *kMainLabelFont = nil;
static UIColor *kMainLabelColor = nil;

static UIFont *kDetailLabelFont = nil;
static UIColor *kDetailLabelColor = nil;

static NSString *kHudSuccessImageName = @"icon_success_HUD";
static NSString *kHudErrorImageName = @"icon_error_HUD";

static UIView *kCustomSuccessView = nil;
static UIView *kCustomErrorView = nil;
static UIView *kCustomLoadingView = nil;
static UIView<MBProgressHUDAnimatedView> *kCustomLoadingAnimationView = nil;

@implementation MBProgressHUD (BTFoundation)

// Defaults. Same as ones hardcoded in MBProgressHUD
+ (UIFont *)defaultMainLabelFont
{
   return [UIFont boldSystemFontOfSize:16.f];
}

+ (UIColor *)defaultMainLabelColor
{
    return [UIColor whiteColor];
}

+ (UIFont *)defaultDetailLabelFont
{
    return [UIFont boldSystemFontOfSize:12.f];
}

+ (UIColor *)defaultDetailLabelColor
{
    return [UIColor whiteColor];
}

#pragma mark - Configuration

+ (void)bt_configureDefaultTimeout:(NSTimeInterval)timeout
{
    kLoadingTimeout = timeout;
}

+ (NSTimeInterval)bt_defaultTimeout
{
    return kLoadingTimeout;
}

+ (void)bt_configureDefaultHideDelay:(NSTimeInterval)hideDelay
{
    kHideDelay = hideDelay;
}

+ (NSTimeInterval)bt_defaultHideDelay
{
    return kHideDelay;
}

+ (void)bt_configureMinSize:(CGSize)size
{
    kMinSizeWidth = size.width;
    kMinSizeHeight = size.height;
}

+ (CGSize)bt_minSize
{
    return CGSizeMake(kMinSizeWidth, kMinSizeHeight);
}

+ (void)bt_configureMargin:(CGFloat)margin
{
    kMargin = margin;
}

+ (CGFloat)bt_margin
{
    return kMargin;
}

+ (void)bt_configureCornerRadius:(CGFloat)cornerRadius
{
    kCornerRadius = cornerRadius;
}

+ (CGFloat)bt_cornerRadius
{
    return kCornerRadius;
}

+ (void)bt_configureMainLabelFont:(UIFont *)font
{
    kMainLabelFont = font;
}

+ (void)bt_configureMainLabelTextColor:(UIColor *)color
{
    kMainLabelColor = color;
}

+ (UIColor *)bt_mainLabelColor
{
    return kMainLabelColor ? kMainLabelColor : [self defaultMainLabelColor];
}

+ (UIFont *)bt_mainLabelFont
{
    return kMainLabelFont ? kMainLabelFont : [self defaultMainLabelFont];
}

+ (void)bt_configureDetailLabelFont:(UIFont *)font
{
    kDetailLabelFont = font;
}

+ (void)bt_configureDetailLabelTextColor:(UIColor *)color
{
    kDetailLabelColor = color;
}

+ (UIColor *)bt_detailLabelColor
{
    return kDetailLabelColor ? kDetailLabelColor : [self defaultDetailLabelColor];
}

+ (UIFont *)bt_detailLabelFont
{
    return kDetailLabelFont ? kDetailLabelFont : [self defaultDetailLabelFont];
}

+ (void)bt_configureSuccessImageName:(NSString *)imgName
{
    kHudSuccessImageName = imgName;
}

+ (void)bt_configureErrorImageName:(NSString *)imgName
{
    kHudErrorImageName = imgName;
}

+ (NSString *)bt_successImageName
{
    return kHudSuccessImageName;
}

+ (NSString *)bt_errorImageName
{
    return kHudErrorImageName;
}

+ (void)bt_configureSuccessCustomView:(UIView *)view
{
    kCustomSuccessView = view;
}

+ (void)bt_configureErrorCustomView:(UIView *)view
{
    kCustomErrorView = view;
}

+ (UIView *)bt_successCustomView
{
    return kCustomSuccessView;
}

+ (UIView *)bt_errorCustomView
{
    return kCustomErrorView;
}

+ (void)bt_configureLoadingCustomView:(UIView *)view
{
    kCustomLoadingView = view;
}

+ (UIView *)bt_loadingCustomView
{
    return kCustomLoadingView;
}

+ (void)bt_configureLoadingCustomAnimationView:(UIView<MBProgressHUDAnimatedView> *)view
{
    kCustomLoadingAnimationView = view;
}

+ (UIView *)bt_loadingCustomAnimationView
{
    return kCustomLoadingAnimationView;
}

#pragma mark - helper
+ (BOOL)ableToFeedMessageInOneLine:(NSString *)message inView:(UIView *)view
{
    CGFloat contentWidth = CGRectGetWidth(view.bounds) - 4 * kMargin; // hardcoded based on implementation of MBProgressHUD;
    
    UIFont *font = kMainLabelFont ? kMainLabelFont : [self defaultMainLabelFont];
    
    CGSize size = [message bt_rectSizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    
    return size.height <= ceil(font.lineHeight);
}

+ (void)configureHudStyle:(MBProgressHUD *)hud
{
    hud.minSize = [MBProgressHUD bt_minSize];
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = kMargin;
    hud.cornerRadius = kCornerRadius;
    hud.labelFont = kMainLabelFont ? kMainLabelFont : [self defaultMainLabelFont];
    hud.labelColor = kMainLabelColor ? kMainLabelColor : [self defaultMainLabelColor];
    hud.detailsLabelFont = kDetailLabelFont ? kDetailLabelFont : [self defaultDetailLabelFont];
    hud.detailsLabelColor = kDetailLabelColor ? kDetailLabelColor : [self defaultDetailLabelColor];
}

#pragma mark - Display
+ (instancetype)bt_showLoadingHUDInWindow
{
    return [self bt_showLoadingHUDInView:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)bt_showLoadingHUDInView:(UIView *)view
{
    return [self bt_showLoadingHUD:nil inView:view];
}

+ (instancetype)bt_showLoadingHUD:(NSString *)text inView:(UIView *)view
{
    return [self bt_showLoadingHUD:text inView:view hideAfterDelay:kLoadingTimeout];
}

+ (instancetype)bt_showLoadingHUD:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    [self hideAllHUDsForView:view animated:NO];

    MBProgressHUD *hud = [self showHUDAddedTo:view animated:YES];
    
    [self configureHudStyle:hud];
    
    if (text.length) {
        hud.labelText = text;
    }
    
    if (kCustomLoadingAnimationView) {
        hud.customView = kCustomLoadingAnimationView;
        hud.mode = MBProgressHUDModeCustomView;
        [kCustomLoadingAnimationView startAnimation];
    } else if (kCustomLoadingView) {
        hud.customView = kCustomLoadingView;
        hud.mode = MBProgressHUDModeCustomView;
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    [hud hide:YES afterDelay:delay];

    return hud;
}

+ (instancetype)bt_showErrorHUD:(NSString *)text inView:(UIView *)view
{
    if ([self ableToFeedMessageInOneLine:text inView:view]) {
        return [self bt_showErrorHUD:text detailText:nil inView:view];
    }
    else {
        return [self bt_showErrorHUD:nil detailText:text inView:view];
    }
}

+ (instancetype)bt_showErrorHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view
{
    return [self bt_showErrorHUD:text detailText:detailText inView:view delay:kHideDelay];
}

+ (instancetype)bt_showErrorHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view delay:(NSTimeInterval)delay
{
    [self hideAllHUDsForView:view animated:NO];

    MBProgressHUD *hud = [self showHUDAddedTo:view animated:YES];
    
    [self configureHudStyle:hud];
    
    if (text != nil) {
        hud.labelText = text;
    }

    if (detailText != nil) {
        hud.detailsLabelText = detailText;
    }

    hud.mode = MBProgressHUDModeCustomView;
    
    if (kCustomErrorView) {
        hud.customView = kCustomErrorView;
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kHudErrorImageName]];
    }

    if (delay != 0) {
        [hud hide:YES afterDelay:delay];
    }

    return hud;
}

+ (instancetype)bt_showSuccessHUD:(NSString *)text inView:(UIView *)view
{
    if ([self ableToFeedMessageInOneLine:text inView:view]) {
        return [self bt_showSuccessHUD:text detailText:nil inView:view];
    } else {
        return [self bt_showSuccessHUD:nil detailText:text inView:view];
    }
}

+ (instancetype)bt_showSuccessHUD:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view
{
    [self hideAllHUDsForView:view animated:NO];

    MBProgressHUD *hud = [self showHUDAddedTo:view animated:YES];
    
    [self configureHudStyle:hud];
    
    if (text != nil) {
        hud.labelText = text;
    }

    if (detailText != nil) {
        hud.detailsLabelText = detailText;
    }

    hud.mode = MBProgressHUDModeCustomView;
    
    if (kCustomSuccessView) {
        hud.customView = kCustomSuccessView;
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kHudSuccessImageName]];
    }
    
    [hud hide:YES afterDelay:kHideDelay];

    return hud;
}

+ (instancetype)bt_showProgressLoadingHUDInView:(UIView*)view
{
    [self hideAllHUDsForView:view animated:NO];

    MBProgressHUD *hud = [self showHUDAddedTo:view animated:YES];
    
    [self configureHudStyle:hud];
    
    hud.mode = MBProgressHUDModeDeterminate;
    
    return hud;
}

+ (BOOL)bt_dismissHUDInView:(UIView *)view
{
    return [self hideHUDForView:view animated:YES];
}

+ (BOOL)bt_dismissHUDInWindow
{
    return [self bt_dismissHUDInView:[UIApplication sharedApplication].keyWindow];
}

@end
