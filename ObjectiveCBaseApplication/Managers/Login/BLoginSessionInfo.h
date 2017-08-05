//
//  BLoginSessionInfo.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BElement.h"

@interface BLoginSessionInfo : BElement

@property (nonatomic, assign, readonly) NSInteger identifier;
@property (nonatomic, strong, readonly) NSString *mobile;
@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) NSString *role;

- (instancetype)initWithIdentifier:(NSInteger)identifier
                            mobile:(NSString *)mobile
                             token:(NSString *)token
                              role:(NSString *)role;

- (BOOL)isUserRetailer;

@end
