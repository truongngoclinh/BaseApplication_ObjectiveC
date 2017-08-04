//
//  CPSolidButton.h
//  Cyberpay
//
//  Created by Andrew Eng on 23/7/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CPSolidButtonStyle) {
    CPSolidButtonStyleNone              = 0, // System style
    CPSolidButtonStyleMain              = 1, // Dark background + Light text
    CPSolidButtonStyleLight             = 2, // Light text + Dark background, in color
    CPSolidButtonStyleLightBlackWhite   = 3  // Light text + Dark background, in black + white
};

@interface CPSolidButton : UIButton

- (instancetype)initWithStyle:(CPSolidButtonStyle)style;
- (instancetype)initWithStyle:(CPSolidButtonStyle)style shouldScale:(BOOL)shouldScale;

@property (nonatomic, assign) CPSolidButtonStyle style;
@property (nonatomic, assign) BOOL shouldScale;

@end

NS_ASSUME_NONNULL_END
