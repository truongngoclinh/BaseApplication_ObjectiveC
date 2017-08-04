//
//  BSolidButton.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BSolidButtonStyle) {
    BSolidButtonStyleNone              = 0, // System style
    BSolidButtonStyleMain              = 1, // Dark background + Light text
    BSolidButtonStyleLight             = 2, // Light text + Dark background, in color
    BSolidButtonStyleLightBlackWhite   = 3  // Light text + Dark background, in black + white
};

@interface BSolidButton : UIButton

- (instancetype)initWithStyle:(BSolidButtonStyle)style;
- (instancetype)initWithStyle:(BSolidButtonStyle)style shouldScale:(BOOL)shouldScale;

@property (nonatomic, assign) BSolidButtonStyle style;
@property (nonatomic, assign) BOOL shouldScale;

@end

NS_ASSUME_NONNULL_END
