//
//  NSError+BWebViewError.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+BWebViewError.h"

@implementation NSError (BWebViewError)

- (BOOL)b_isWebViewError
{
    return [self.domain isEqual: @"WebKitErrorDomain"];
}

- (BOOL)b_shouldHandleWebViewError
{
    // https://happyteamlabs.com/blog/ios-uiwebview-errors-to-look-out-for/
    //
    // Ignore error if error is due to redirecting/cancelation of pending request,
    // or due to "Frame Load Interrupted" because of app-store link or sometimes -webView:shouldStartLoadWithRequest returning NO
    // or hud is showing.
    return (!(self.domain == NSURLErrorDomain && self.code == NSURLErrorCancelled) && !([self.domain isEqual: @"WebKitErrorDomain"] && self.code == 102));
}

@end
