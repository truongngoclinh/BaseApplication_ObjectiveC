//
//  UITextField+RightAlignedNoSpaceFix.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Since iOS7, right-aligned textfield will not show the last space.
 This fix is disabed by default */
@interface UITextField (RightAlignedNoSpaceFix)

- (void)b_enableRightAlignedNoSpaceFix;
- (void)b_disableRightAlignedNoSpaceFix;

- (NSString * _Nullable)b_textNotAffectedByFix;

@end

NS_ASSUME_NONNULL_END
