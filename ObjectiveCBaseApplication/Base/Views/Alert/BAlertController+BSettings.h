//
//  BAlertController+BSettings.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BAlertController.h"
#import "BAlertController+InfoView.h"

@interface BAlertController (BSettings)

+ (BAlertController *)b_alertSettingsControllerForNotificationTurnOn;

+ (BAlertController *)b_alertSettingsControllerForNotificationTurnOff;

+ (BAlertController *)b_alertSettingsControllerForCameraPermission;

+ (BAlertController *)b_alertSettingsControllerForPhotoLibraryPermission;

@end
