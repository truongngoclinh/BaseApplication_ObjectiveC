//
//  NSString+Size.h
//  BeeShop
//
//  Created by ZhangLianzhou on 1/7/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(BTSize)

//ConstrainedSize is max
- (CGSize)bt_rectSizeWithFont:(UIFont *)font;

//Default lineBreakMode of NSLineBreakByWordWrapping
-(CGSize)bt_rectSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)constrainedSize;

-(CGSize)bt_rectSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
