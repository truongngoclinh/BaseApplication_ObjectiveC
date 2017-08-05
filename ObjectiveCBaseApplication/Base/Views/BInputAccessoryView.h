//
//  BInputAccessoryView.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 2/2/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BInputAccessoryView;

@protocol BInputAccessoryViewDelegate <NSObject>

- (void)inputAccessoryViewDidTapDone:(BInputAccessoryView *)view;

@optional
- (void)inputAccessoryViewDidTapArrow:(BInputAccessoryView *)view;

@end

@interface BInputAccessoryView : UIView

@property (nonatomic, weak) id<BInputAccessoryViewDelegate> delegate;

@property (nonatomic, assign) BOOL hideArrow;
@property (nonatomic, assign) BOOL doneEnabled;
/** Defaults to TXT(@"button_done") */
@property (nonatomic, strong) NSString *doneButtonTitle;

@end

NS_ASSUME_NONNULL_END
