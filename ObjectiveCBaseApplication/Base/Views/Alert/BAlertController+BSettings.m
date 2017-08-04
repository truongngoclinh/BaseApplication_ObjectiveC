//
//  BAlertController+BSettings.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BAlertController+BSettings.h"
#import "BCountryLogic.h"

@implementation BAlertController (BSettings)

+ (BAlertController *)b_alertSettingsControllerForNotificationTurnOn
{
    NSString *detail = [NSString stringWithFormat:TXT(@"label_push_setting_alert"), [BCountryLogic currentCountryLogic].appName];
    BAlertController *alertController = [BAlertController
                                          b_alertInfoControllerWithTitle:TXT(@"alert_title_turn_on_notification")
                                          detail:detail];
    [alertController b_addSettingActions];
    return alertController;
}

+ (BAlertController *)b_alertSettingsControllerForNotificationTurnOff
{
    NSString *detail = [NSString stringWithFormat:TXT(@"label_push_setting_off_alert"), [BCountryLogic currentCountryLogic].appName];
    BAlertController *alertController = [BAlertController
                                          b_alertInfoControllerWithTitle:TXT(@"alert_title_turn_off_notification")
                                          detail:detail];
    [alertController b_addSettingActions];
    return alertController;
}

+ (BAlertController *)b_alertSettingsControllerForCameraPermission
{
    NSString *detail = [NSString stringWithFormat:TXT(@"alert_camera_setting"), [BCountryLogic currentCountryLogic].appName];
    BAlertController *alertController = [BAlertController
                                          b_alertInfoControllerWithTitle:TXT(@"title_information")
                                          detail:detail];
    [alertController b_addSettingActions];
    return alertController;
}

+ (BAlertController *)b_alertSettingsControllerForPhotoLibraryPermission
{
    NSString *detail = [NSString stringWithFormat:TXT(@"alert_photo_library_setting"), [BCountryLogic currentCountryLogic].appName];
    BAlertController *alertController = [BAlertController
                                          b_alertInfoControllerWithTitle:TXT(@"title_information")
                                          detail:detail];
    [alertController b_addSettingActions];
    return alertController;
}

- (void)b_addSettingActions
{
    [self addActionTitle:TXT(@"button_ok") onTriggered:nil];
    
    if (&UIApplicationOpenSettingsURLString) {
        [self addActionTitle:TXT(@"button_settings") onTriggered:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
    }
}

@end
