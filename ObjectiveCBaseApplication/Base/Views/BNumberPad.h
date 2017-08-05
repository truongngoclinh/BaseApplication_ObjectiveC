//
//  BNumberPad.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 17/3/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNumberPad;
@protocol BNumberPadDelegate <NSObject>

- (void)numberPad:(BNumberPad *)numberPad didTapKey:(NSString *)key;
- (void)numberPadDidTapBackspace:(BNumberPad *)numberPad;

@end

@interface BNumberPad : UIView

@property (nonatomic, weak) id<BNumberPadDelegate> delegate;
@property (nonatomic, assign) BOOL showDecimalSymbol;

+ (CGFloat)requiredHeight;

@end
