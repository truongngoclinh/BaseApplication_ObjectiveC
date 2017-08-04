//
//  BAlertController+InfoView.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BAlertController+InfoView.h"

@implementation BAlertController (InfoView)

+ (UIFont *)b_alertInfoTitleFont
{
    return [BAlertInfoView titleFont];
}

+ (UIFont *)b_alertInfoDetailFont
{
    return [BAlertInfoView detailFont];
}

+ (BAlertController *)b_alertInfoControllerWithTitle:(NSString *)title detail:(NSString *)detail
{
    BAlertController *alertController = [[BAlertController alloc] initWithNibName:nil bundle:nil];
    alertController.customView = [BAlertInfoView alertInfoViewWithTitle:title
                                                                  detail:detail];
    return alertController;
}

+ (BAlertController *)b_alertSuccessControllerWithDetail:(NSString *)detail
{
    BAlertController *alertController = [[BAlertController alloc] initWithNibName:nil bundle:nil];
    alertController.customView = [BAlertInfoView alertInfoViewWithTitle:nil
                                                                  detail:detail
                                                               topOffset:30];
    alertController.centerIconImage = [UIImage imageNamed:@"new_scale_ui_popup_icon_successful"];
    return alertController;
}

+ (BAlertController *)b_alertFailureControllerWithDetail:(NSString *)detail
{
    BAlertController *alertController = [[BAlertController alloc] initWithNibName:nil bundle:nil];
    alertController.customView = [BAlertInfoView alertInfoViewWithTitle:nil
                                                                  detail:detail
                                                               topOffset:30];
    alertController.centerIconImage = [UIImage imageNamed:@"ic_popup_sthwrong"];
    return alertController;
}

+ (BAlertController *)b_alertInfoControllerWithAttributedTitle:(NSAttributedString *)attributedTitle
                                                attributedDetail:(NSAttributedString *)attributedDetail
{
    BAlertController *alertController = [[BAlertController alloc] initWithNibName:nil bundle:nil];
    alertController.customView = [BAlertInfoView alertInfoViewWithAttributedTitle:attributedTitle
                                                                  attributedDetail:attributedDetail];
    return alertController;
}

@end
