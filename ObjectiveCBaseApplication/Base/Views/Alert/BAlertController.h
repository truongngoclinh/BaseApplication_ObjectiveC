//
//  BAlertController.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BViewController.h"

typedef void(^BAlertControllerBlock)(void);

@class BAlertController;
@protocol BAlertControllerDelegate <NSObject>
@optional
- (BOOL)alertController:(BAlertController *)alertController shouldTriggerForIndex:(NSInteger)index;
- (BOOL)shouldBecomeFirstResponderWhenViewWillAppearForAlertController:(BAlertController *)alertController;
- (void)didDismissAlertController:(BAlertController *)alertController;
@end

@interface BAlertController : BViewController

@property (nonatomic, strong) UIImage *centerIconImage;
@property (nonatomic, strong, readonly) UIView *alertView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, weak) id<BAlertControllerDelegate> delegate;

/** Defaults to NO */
@property (nonatomic, assign) BOOL allowsTapToDismissWhenHaveButton;

- (void)addActionTitle:(NSString *)title onTriggered:(BAlertControllerBlock)triggeredBlock;

@end
