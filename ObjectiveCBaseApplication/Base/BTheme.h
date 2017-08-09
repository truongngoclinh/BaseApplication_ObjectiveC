//
//  BTheme.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat BThemeCellHeightDefault;
extern const CGFloat BThemeSectionGapDefault;
extern const CGFloat BThemePaddingDefault;
extern const CGFloat BThemeButtonHeightDefault;
extern const CGFloat BThemeButtonHeightCompact;

extern const CGFloat BThemeTextFieldHeightDefault;
extern const CGFloat BThemeLabelHeightDefault;
extern const CGFloat BThemeDefaultMarginTop;

@interface BTheme : NSObject

#pragma mark - Colors

/**384267*/
+ (UIColor *)navigationBarColor;

/***488cf1*/
+ (UIColor *)colorMain;
/***3b81eb*/
+ (UIColor *)colorMainSelected;
/***2B3E30 10%*/
+ (UIColor *)colorMainDisabled;

/**eff3f9 100%*/
+ (UIColor *)backgroundColor;
/**ffffff*/
+ (UIColor *)backgroundColorLight;
/**2b2e30 5%*/
+ (UIColor *)backgroundColorHighlighted;

/**2b2e30 90%*/
+ (UIColor *)textColor;
/**2b2e30 70%*/
+ (UIColor *)textColorLight;
/**2b2e30 50%*/
+ (UIColor *)textColorLighter;
/**2b2e30 30%*/
+ (UIColor *)textColorLightest;

/**488cf1*/
+ (UIColor *)textColorMain;
/**ff9f21*/
+ (UIColor *)textColorWarm;
/**27cb7a*/
+ (UIColor *)textColorSuccess;
/**ff5b18*/
+ (UIColor *)textColorError;

/**dde2e5*/
+ (UIColor *)dividerColor;
/**ffffff 20%*/
+ (UIColor *)dividerColorLight;

/**27cb7a*/
+ (UIColor *)successColor;
/**ff5b18*/
+ (UIColor *)errorColor;

/**eff3f9 100%*/
+ (UIColor *)footerColor;

#pragma mark - Font

+ (UIFont *)fontOfSize:(CGFloat)size;
+ (UIFont *)mediumFontOfSize:(CGFloat)size;
+ (UIFont *)boldFontOfSize:(CGFloat)size;
+ (UIFont *)lightFontOfSize:(CGFloat)size;

#pragma mark - Utility

+ (UIImage *)imageForColor:(UIColor *)color;
+ (UIImage *)imageForColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
