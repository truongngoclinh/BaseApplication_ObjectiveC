//
//  BTSectionElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 28/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTSectionElement.h"

@implementation BTSectionElement

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bottomPadding = BTSectionElementBottomPaddingNotSet;
    }
    return self;
}

- (NSInteger)numberOfRows
{
    NSInteger count = self.rows.count;

    for (BTElement *element in self.rows) {
        if (element.isChildrenActive) {
            count += element.children.count;
        }
    }

    return count;
}

- (void)setRows:(NSArray *)rows
{
    _rows = rows;

    for (BTElement *row in rows) {
        row.rootElement = self.rootElement;
    }
}

- (BTElement *)elementForKey:(NSString *)key
{
    for (BTElement *row in self.rows) {
        if ([row.key isEqualToString:key]) {
            return row;
        }
        for (BTElement *child in row.children) {
            if ([child.key isEqualToString:key]) {
                return child;
            }
        }
    }

    return nil;
}

- (UIView *)viewForHeader
{
    return self.headerView;
}

- (CGFloat)heightForHeader
{
    return self.headerView.frame.size.height;
}

- (UIView *)viewForFooter
{
    return self.footerView;
}

- (CGFloat)heightForFooter
{
    return self.footerView.frame.size.height;
}

@end
