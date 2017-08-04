//
//  BTextFieldNumberController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BTextFieldNumberController.h"
#import "BNumberFormatter.h"

@interface BTextFieldNumberController ()

@property (nonatomic, strong) BNumberFormatter *numberFormatter;

@end

@implementation BTextFieldNumberController

- (BNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        _numberFormatter = [[BNumberFormatter alloc] init];
    }
    return _numberFormatter;
}

- (NSString *)validReplacementString:(NSString *)replacementString
                            forRange:(NSRange)range
                         inTextField:(UITextField *)textField
{
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];

    // Allow decimal separator if current string don't already have decimal separator
    if (self.enableFractionDigits) {
        [allowedCharacterSet addCharactersInString:self.numberFormatter.decimalSeparator];
    }
    
    NSArray *validComponents = [replacementString componentsSeparatedByCharactersInSet:[allowedCharacterSet invertedSet]];
    NSString *validString = [validComponents componentsJoinedByString:@""];
    
    if (self.enableFractionDigits) {
        NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:validString];
        NSArray *components = [finalString componentsSeparatedByString:self.numberFormatter.decimalSeparator];
        
        // There are more than 1 decimal separator
        if (components.count > 2) {
            validString = @"";
        }
        else if (components.count == 2) {
            
            // Check number of decimal place
            NSString *fractionDigitString = components[1];
            if (self.maximumFractionDigits && (fractionDigitString.length > self.maximumFractionDigits)) {
                validString = @"";
            }
        }
    }
    
    return [super validReplacementString:validString forRange:range inTextField:textField];
}

@end
