//
//  BTraverseItem.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 7/10/15.
//  Copyright © 2015 Garena. All rights reserved.
//

#import "BTraverseItem.h"

@implementation BTraverseItem

- (instancetype)initWithPathComponents:(NSArray<NSString *> *)pathComponents
                                object:(nullable id)object;
{
    self = [super init];
    if (self) {
        NSParameterAssert(pathComponents.count);
        
        _pathComponents = pathComponents;
        _object = object;
    }
    return self;
}

@end
