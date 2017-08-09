//
//  BTWeakObject.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 7/8/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTWeakObject.h"

@interface BTWeakObject ()

@property (nonatomic, weak) id object;

@end

@implementation BTWeakObject

- (id)initWithObject:(id)object
{
    self = [super init];
    
    if (self) {
        self.object = object;
    }
    
    return self;
}

- (id)object
{
    return _object;
}

- (BOOL)isNil
{
    return self.object == nil;
}

- (NSString *)description
{
    NSString *description = [super description];
    
    return [NSString stringWithFormat:@"%@:%@", description, self.object];
}

@end
