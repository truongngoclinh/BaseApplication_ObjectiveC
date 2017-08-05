//
//  UIAlertView+SJBlock.m
//  BeeTalk
//
//  Created by garena on 23/4/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "UIAlertView+SJBlock.h"

#import <objc/runtime.h>

static char ALERT_BUTTONS_CALLBACKS_IDENTIFIER;
static char SHOULD_DISABLE_BUTTON_IDENTIFIER;

@implementation UIAlertView (SJBlock)

+ (id)alertViewTitle:(NSString *)title message:(NSString*)message
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                    message:message delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];

    alertView.delegate = alertView;

    return alertView;
}

- (NSInteger)addButtonTitle:(NSString *)title onTriggered:(UIAlertViewBlock)triggeredBlock
{
    NSInteger index = [self addButtonWithTitle:title];

    [self addForButtonAtIndex:index completion:triggeredBlock];

    return index;
}

- (void)addForButtonAtIndex:(NSInteger)index completion:(UIAlertViewBlock)triggeredBlock
{
    NSMutableDictionary *callbacks = [self buttonsCallbacks];

    if (callbacks == nil) {
        callbacks = [NSMutableDictionary dictionary];
        [self setButtonsCallbacks:callbacks];
    }

    if (triggeredBlock) {
        [callbacks setObject:triggeredBlock forKey:@(index)];
    }
}

- (NSInteger)addCancelTitle:(NSString *)title
{
    NSInteger index = [self addButtonTitle:title onTriggered:nil];

    self.cancelButtonIndex = index;
    
    return index;
}

- (NSMutableDictionary *)buttonsCallbacks
{
    return objc_getAssociatedObject(self, &ALERT_BUTTONS_CALLBACKS_IDENTIFIER);
}

- (void)setButtonsCallbacks:(NSMutableDictionary *)dictionary
{
    objc_setAssociatedObject(self, &ALERT_BUTTONS_CALLBACKS_IDENTIFIER, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setShouldDisableFirstOtherButtonIfTextEmpty:(BOOL)shouldDisableFirstOtherButtonIfTextEmpty
{
    objc_setAssociatedObject(self, &SHOULD_DISABLE_BUTTON_IDENTIFIER, @(shouldDisableFirstOtherButtonIfTextEmpty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldDisableFirstOtherButtonIfTextEmpty
{
    return [objc_getAssociatedObject(self, &SHOULD_DISABLE_BUTTON_IDENTIFIER) boolValue];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSMutableDictionary *callbacks = [self buttonsCallbacks];

    UIAlertViewBlock callback = [callbacks objectForKey:@(buttonIndex)];

    if (callback) {
        callback();
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.alertViewStyle != UIAlertViewStylePlainTextInput) {
        return YES;
    }

    if (!self.shouldDisableFirstOtherButtonIfTextEmpty) {
        return YES;
    }

    NSString *text = [[alertView textFieldAtIndex:0] text];

    return (text.length> 0 )?YES:NO;
}


@end
