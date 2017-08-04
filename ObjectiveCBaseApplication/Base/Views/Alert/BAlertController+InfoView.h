//
//  BAlertController+InfoView.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BAlertController.h"
#import "BAlertInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BAlertController (InfoView)

+ (UIFont *)b_alertInfoTitleFont;
+ (UIFont *)b_alertInfoDetailFont;

+ (BAlertController *)b_alertInfoControllerWithTitle:(NSString * _Nullable)title detail:(NSString *)detail;
+ (BAlertController *)b_alertSuccessControllerWithDetail:(NSString *)detail;
+ (BAlertController *)b_alertFailureControllerWithDetail:(NSString *)detail;
+ (BAlertController *)b_alertInfoControllerWithAttributedTitle:(NSAttributedString *)attributedTitle
                                                attributedDetail:(NSAttributedString *)attributedDetail;

@end

NS_ASSUME_NONNULL_END
