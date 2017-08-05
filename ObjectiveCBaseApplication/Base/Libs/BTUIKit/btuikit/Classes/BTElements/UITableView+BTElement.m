//
//  UITableView+BTElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 13/3/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "UITableView+BTElement.h"

#import "BTElement.h"

@implementation UITableView (BTElement)

- (void)reloadElements:(NSArray *)elements
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:elements.count];
    for (BTElement *element in elements) {
        NSIndexPath *indexPath = [element indexPathForTableView:self];

        // Reload only visible elements
        if (indexPath) {
            [indexPaths addObject:indexPath];
        }
    }

    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

@end
