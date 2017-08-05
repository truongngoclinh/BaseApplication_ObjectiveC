//
//  BElement.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 24/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BElement.h"

@interface BElement ()

@property (nonatomic, assign, readonly) NSUInteger uniqueId;
@property (nonatomic, weak) BElementCell *cell;

@end

@implementation BElement

- (instancetype)init
{
    self = [super init];
    if (self) {
        static NSUInteger uniqueId = 1;
        _uniqueId = uniqueId++;
    }
    return self;
}

- (Class)cellClass
{
    return [BElementCell class];
}

- (BTElementCell *)cellForTableView:(UITableView *)tableView
{
    BTElementCell *cell = [super cellForTableView:tableView];
    
    if ([cell isKindOfClass:[BElementCell class]]) {
        BElementCell *cpCell = (id)cell;
        cpCell.elementId = self.uniqueId;
        
        _cell = (id)cpCell;
    } else {
        NSParameterAssert(NO);
    }
    
    return cell;
}

#pragma mark - Accessors

- (BElementCell *)cell
{
    return (_cell.elementId == self.uniqueId) ? _cell : nil;
}

@end
