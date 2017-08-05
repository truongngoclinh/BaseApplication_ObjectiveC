//
//  NSError+BError.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define BNetworkErrorDomain NSURLErrorDomain
#define BResponseErrorDomain AFURLResponseSerializationErrorDomain
//#define BTransformerErrorHandlingErrorDomain MTLTransformerErrorHandlingErrorDomain
#define BModelErrorDomain @"MTLModelErrorDomain"

@interface NSError (BError)

+ (NSError *)b_errorWithDomain:(NSString *)domain code:(NSInteger)code;
+ (NSError *)b_errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message;
+ (NSError *)b_errorWithDomain:(NSString *)domain
                           code:(NSInteger)code
                        message:(NSString *)message
                       userInfo:(NSDictionary *)userInfo;

- (NSString *)b_errorMessage;

@end

@interface NSError (BNetwork)

- (BOOL)b_isNetworkError;
- (BOOL)b_isResponseError;

@end

@interface NSError (BMantle)

- (BOOL)b_isResponseParsingError;
- (BOOL)b_isResponseValidatingParsedResultError;

@end
