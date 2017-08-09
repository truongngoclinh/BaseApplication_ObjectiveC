//
//  NSArray+BTAdditions.h
//  BeeShop
//
//  Created by garena on 14/7/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^BTMapBlock)(id obj);
typedef BOOL (^BTFindBlock)(id obj);
typedef BOOL (^BTFilterBlock)(id obj);

@interface NSArray (BTFoundation)

/**
Iterates throught the array and apply the given block and add the result to a new array
@param mapBlock - a block that returns a object that is added to the resultant array. 
                  If it is nil, it is not added to the resultant array
 
@code
 NSArray *countList = [@[@"hello", @"map"] bt_map:^id(NSString *obj) {
 return @(obj.length);
 }];
 //Result:countList:@[5,3]
@endcode
*/
- (NSArray *)bt_map:(BTMapBlock)mapBlock;


/**
Iterates through the array and apply the given block and returns the first object that meets the condition
Returns nil if no object is found
*/
- (id)bt_find:(BTFindBlock)findBlock;

/**
Safe method to retrieve first N objects in an array.
*/
- (NSArray *)bt_firstNObjects:(int)limit;

- (NSArray *)bt_filter:(BTFilterBlock)filterBlock;

@end
