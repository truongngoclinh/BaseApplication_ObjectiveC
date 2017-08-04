//
//  CPSelectButton.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

@interface BSelectButton : UIButton

@property (nonatomic, assign) BOOL hideTick;

+ (UIFont *)font;
+ (UIFont *)selectedFont;

@end
