//
//  BTextFieldController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BTextFieldController.h"

@implementation BTextFieldController

- (NSString *)validReplacementString:(NSString *)replacementString
                            forRange:(NSRange)range
                         inTextField:(UITextField *)textField
{
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];

    if (self.maximumCharacterCount && finalString.length > self.maximumCharacterCount) {
        return @"";
    }

    return replacementString;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    NSString *validReplacementString = [self validReplacementString:string forRange:range inTextField:textField];
    NSParameterAssert(validReplacementString);

    if ([validReplacementString isEqualToString:string]) {
        return YES;
    }
    
    if (validReplacementString.length == 0) {
        return NO;
    }
    
    // Manually replace text
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:validReplacementString];
    
    // Calculate final cursor position
    NSUInteger cursorIndex = range.location + validReplacementString.length;
    UITextPosition *cursorPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:cursorIndex];
    
    // Set cursor position
    [textField setSelectedTextRange:[textField textRangeFromPosition:cursorPosition toPosition:cursorPosition]];
    
    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.delegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    return YES;
}

@end
