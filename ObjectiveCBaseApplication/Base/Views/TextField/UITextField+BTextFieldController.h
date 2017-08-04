//
//  UITextField+BTextFieldController.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BTextFieldController;
@interface UITextField (BTextFieldController)

@property (nonatomic, strong, readonly) BTextFieldController *b_TextFieldController;

/** 
 * Once a controller has been attached, do not modify self.delegate.
 * Instead, use self.b_controller.delegate
 */
- (void)b_attachTextFieldController:(BTextFieldController *)controller;
- (void)b_detachTextFieldController;

@end

NS_ASSUME_NONNULL_END
