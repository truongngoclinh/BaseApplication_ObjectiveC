//
//  UIView+BAutolayout.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIView (BAutolayout)

/* Higher than default with 100 */
- (void)b_setHorizontalCompressionResistanceAndHuggingPriorityHigher;

/* Higher than default with 100 */
- (void)b_setVerticalCompressionResistanceAndHuggingPriorityHigher;

- (void)b_setHorizontalCompressionResistanceAndHuggingPriorityHigherThanDefault:(NSInteger)higherThanDefault;
- (void)b_setVerticalCompressionResistanceAndHuggingPriorityHigherThanDefault:(NSInteger)higherThanDefault;

@end
