//
//  UIColor+BAdditions.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BAdditions)

+ (UIColor *)b_colorWithHex:(NSString *)hex;
+ (UIColor *)b_colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;
- (CGFloat)b_alpha;

@end
