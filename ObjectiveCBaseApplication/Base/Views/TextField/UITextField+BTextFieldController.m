//
//  UITextField+BTextFieldController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "UITextField+BTextFieldController.h"
#import "BTextFieldController.h"
#import <objc/runtime.h>

static char BTextFieldControllerIdentifier;

@implementation UITextField (BTextFieldController)

- (void)b_attachTextFieldController:(BTextFieldController *)controller
{
    [self b_detachTextFieldController];
    
    if (controller) {
        self.b_TextFieldController = controller;
        if (self.delegate) {
            self.b_TextFieldController.delegate = self.delegate;
        }
        self.delegate = self.b_TextFieldController;
    }
}

- (void)b_detachTextFieldController
{
    if (self.b_TextFieldController) {
        if (self.delegate == self.b_TextFieldController) {
            self.delegate = self.b_TextFieldController.delegate;
        }
        self.b_TextFieldController = nil;
    }
}

#pragma mark - Accessors

- (void)setCp_TextFieldController:(BTextFieldController *)b_TextFieldController
{
    objc_setAssociatedObject(self, &BTextFieldControllerIdentifier, b_TextFieldController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BTextFieldController *)b_TextFieldController
{
    return objc_getAssociatedObject(self, &BTextFieldControllerIdentifier);
}

@end
