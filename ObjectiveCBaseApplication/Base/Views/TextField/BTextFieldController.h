//
//  BTextFieldController.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>
#import "UITextField+BTextFieldController.h"

@interface BTextFieldController : NSObject <UITextFieldDelegate>

/** 0 = unlimited. Default: 0 */
@property (nonatomic, assign) NSInteger maximumCharacterCount;

@property (nonatomic, weak) id<UITextFieldDelegate> delegate;

/** 
 * To subclass. Remember to call super
 * @return return value cannot be nil
 */
- (NSString *)validReplacementString:(NSString *)replacementString
                            forRange:(NSRange)range
                         inTextField:(UITextField *)textField;

@end
