//
//  NSArray+BTAdditions.m
//  BeeShop
//
//  Created by garena on 14/7/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "NSArray+BTFoundation.h"

@implementation NSArray (BTFoundation)

- (NSArray *)bt_map:(BTMapBlock)mapBlock {

    NSMutableArray *mappedArray = [NSMutableArray new];

    for (id oneObject in self) {

        id objectToAdd = mapBlock(oneObject);
        if (objectToAdd) {
            [mappedArray addObject:objectToAdd];
        }
    }
    
    return [mappedArray copy];
}

- (id)bt_find:(BTFindBlock)findBlock
{
    for (id oneObject in self) {

        BOOL found = findBlock(oneObject);
        if (found) {
            return oneObject;
        }
    }

    return nil;
}

- (NSArray *)bt_firstNObjects:(int)limit
{
    int fetch = MIN(limit, (int)self.count);
    return [self subarrayWithRange:NSMakeRange(0, fetch)];
}

- (NSArray *)bt_filter:(BTFilterBlock)filterBlock
{
    NSMutableArray *filtered = [NSMutableArray array];

    for (id obj in self) {
        if (filterBlock(obj)) {
            [filtered addObject:obj];
        }
    }

    return [filtered copy];
}

@end
