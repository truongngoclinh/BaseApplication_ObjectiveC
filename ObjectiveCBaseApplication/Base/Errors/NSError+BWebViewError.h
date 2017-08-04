//
//  NSError+BWebViewError.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSError (BWebViewError)

- (BOOL)b_isWebViewError;

- (BOOL)b_shouldHandleWebViewError;

@end
