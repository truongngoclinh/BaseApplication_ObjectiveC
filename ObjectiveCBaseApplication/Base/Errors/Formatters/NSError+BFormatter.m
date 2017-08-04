//
//  NSError+BFormatter.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSError+BFormatter.h"

#import "BDebugDefine.h"
#import "NSError+BAppFormatter.h"

@implementation NSError (BFormatter)

- (NSString *)b_formattedMesssage
{
    return [self b_formattedMesssageForServerError:nil];
}

- (NSString *)b_formattedMesssageForServerError:(BFormatterServerErrorMessageBlock)block
{
    NSString *message = nil;
    
    if ([self b_isAppError]) {
        message = [self b_formattedAppMessage];
    }
    
    else if ([self b_isNetworkError]) {
        message = [self detailedMessageForMessage:TXT(@"error_network")];
    }
    
    else if ([self b_isResponseError]) {
        message = [self detailedMessageForMessage:TXT(@"error_server")];
    }
    
    else if ([self b_isResponseParsingError]) {
        message = [self detailedMessageForMessage:TXT(@"error_wrong_response_format")];
    }
    
    else if ([self b_isResponseValidatingParsedResultError]) {
        message = [self detailedMessageForMessage:TXT(@"error_validating_and_setting_value")];
    }
    
    else {
        
        message = TXT(@"error_unknown");

#ifdef B_INT_DETAILED_ERROR
        message = [NSString stringWithFormat:@"%@: %@ - %@", message, @(self.code), self.localizedDescription];
#endif
    }
    
    if (!message.length) {
        
        // Known error type but unknown error code.
        message = TXT(@"error_unhandled");
        
#ifdef B_INT_DETAILED_ERROR
        message = [NSString stringWithFormat:@"%@: %@ - %@", message, @(self.code), self.localizedDescription];
#endif
        
        NSParameterAssert(NO);
    }
    
    return message;
}

- (NSString *)detailedMessageForMessage:(NSString *)message
{
#ifdef B_DEBUG_DETAILED_ERROR
    message = [NSString stringWithFormat:@"%@: %@", message, [self b_errorMessage]];
#endif
    return message;
}

@end
