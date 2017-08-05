//
//  BTextField.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 30/1/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BTextFieldStyle)
{
    BTextFieldStyleDefault    = 0,
    BTextFieldStyleInputSmall = 2,
    BTextFieldStyleInputNew   = 3
};

@interface BTextField : UITextField

/** Default to UIEdgeInsetsMake(0, BX(4), 0, BX(4)) */
@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, assign) BOOL hideCursor;
@property (nonatomic, assign) BOOL showDecimalSymbol;
@property (nonatomic, assign, readonly) BTextFieldStyle style;
@property (nonatomic, strong, nullable) NSDictionary *placeholderAttributes;

/** If text is right aligned, use this property to get the correct text. */
@property (nonatomic, strong, nullable) NSString *textNotAffectedByRightAlignFix;

- (instancetype)initWithStyle:(BTextFieldStyle)style;
- (instancetype)initWithStyle:(BTextFieldStyle)style shouldScale:(BOOL)shouldScale;

@end

NS_ASSUME_NONNULL_END
