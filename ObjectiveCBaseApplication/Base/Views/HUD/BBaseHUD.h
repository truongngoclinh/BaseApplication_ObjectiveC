//
//  BBaseHUD.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

extern const NSTimeInterval BHUDDurationInfinite;
typedef void(^BHUDCompletion)(void);

@interface BBaseHUD : UIView

@property (nonatomic, assign, readonly) BOOL isShowing;
@property (nonatomic, strong, readonly) UIView *contentView;

/** Optional. Default is white with alpha 0.85 */
@property (nonatomic, strong) UIColor *HUDBackgroundColor;

+ (NSTimeInterval)durationForText:(NSString *)text;

- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration;
- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration completion:(BHUDCompletion)completion;
- (void)hide;

/** Implement in subclass if need. Called when setting up constraints. Call super's implementation first. */
- (void)configureConstraints;

@end
