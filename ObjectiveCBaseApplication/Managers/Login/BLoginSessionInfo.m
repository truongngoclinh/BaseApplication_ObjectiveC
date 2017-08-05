//
//  BLoginSessionInfo.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BLoginSessionInfo.h"

@implementation BLoginSessionInfo

- (instancetype)initWithIdentifier:(NSInteger)identifier
                            mobile:(NSString *)mobile
                             token:(NSString *)token
                              role:(NSString *)role
{
    self = [super init];
    if (self) {
        NSParameterAssert(identifier && mobile.length && token.length && role.length);
        _identifier = identifier;
        _mobile = mobile;
        _token = token;
        _role = role;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"identifier:%@, mobile:%@, token:%d, role:%@",
            @(self.identifier), self.mobile, self.token.length > 0, self.role];
}

- (BOOL)isUserRetailer
{
    NSString *role = self.role;
    NSParameterAssert(role.length);
    
    BOOL result = NO;
    
//    if ([role isEqualToString:BClientRoleRetailer]) {
//        result = YES;
//    } else if ([role isEqualToString:BClientRoleSeller]) {
//        result = NO;
//    } else {
//        NSParameterAssert(NO);
//    }
    
    return result;
}

@end
