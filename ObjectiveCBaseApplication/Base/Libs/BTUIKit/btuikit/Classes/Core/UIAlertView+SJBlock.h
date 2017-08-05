//
//  UIAlertView+SJBlock.h
//  BeeTalk
//
//  Created by garena on 23/4/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewBlock)(void);

@interface UIAlertView (SJBlock) <UIAlertViewDelegate>

+ (id)alertViewTitle:(NSString *)title message:(NSString*)message;

- (NSInteger)addButtonTitle:(NSString *)title onTriggered:(UIAlertViewBlock)triggeredBlock;

- (NSInteger)addCancelTitle:(NSString *)title;

- (void)addForButtonAtIndex:(NSInteger)index completion:(UIAlertViewBlock)triggeredBlock;

@property (nonatomic, assign) BOOL shouldDisableFirstOtherButtonIfTextEmpty;

@end
