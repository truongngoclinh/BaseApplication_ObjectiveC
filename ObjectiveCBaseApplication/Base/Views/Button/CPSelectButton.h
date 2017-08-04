//
//  CPSelectButton.h
//  Cyberpay
//
//  Created by Andrew Eng on 24/7/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSelectButton : UIButton

@property (nonatomic, assign) BOOL hideTick;

+ (UIFont *)font;
+ (UIFont *)selectedFont;

@end
