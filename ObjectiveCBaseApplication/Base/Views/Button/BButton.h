//
//  BButton.h
//  Cyberpay
//
//  Created by Andrew Eng on 30/1/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BButtonLayout)
{
    BButtonLayoutImageLeft   = 0,
    BButtonLayoutImageRight  = 1,
    BButtonLayoutImageTop    = 2,
    BButtonLayoutImageBottom = 3,
};

/**
 *
 * Supports:
 *  - titleEdgeInsets
 *  - imageEdgeInsets
 *
 * Limitation: Does not scale content if size is smaller than required size. 
 *
 */
@interface BButton : UIButton

- (instancetype)initWithLayout:(BButtonLayout)layout;

/** Defaults to YES. */
@property (nonatomic, assign) BOOL shouldScaleImage;

@end
