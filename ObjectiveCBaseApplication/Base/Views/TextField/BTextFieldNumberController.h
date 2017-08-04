//
//  BTextFieldNumberController.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BTextFieldController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTextFieldNumberController : BTextFieldController

/** Default: NO */
@property (nonatomic, assign) BOOL enableFractionDigits;
/** Default: 2, 0 for unlimited */
@property (nonatomic, assign) NSInteger maximumFractionDigits;

@end

NS_ASSUME_NONNULL_END
