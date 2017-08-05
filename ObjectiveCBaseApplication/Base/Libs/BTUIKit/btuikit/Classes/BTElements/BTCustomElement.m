//
//  BTCustomElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 18/4/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTCustomElement.h"

#import "BTCustomElementCell.h"

@interface BTCustomElement ()

@property (nonatomic, strong) UIView *view;

@end

@implementation BTCustomElement

- (id)initWithView:(UIView *)view
{
    self = [super init];

    if (self) {
        self.view = view;
        self.edgeInsets = UIEdgeInsetsMake(-4, -4, -4, -4);
    }

    return self;
}

- (BTElementCell *)cellForTableView:(UITableView *)tableView
{
    BTCustomElementCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];

    if (cell == nil) {
        cell = [[BTCustomElementCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:self.identifier];
    }

    cell.view = self.view;
    NSParameterAssert(self.view);
    cell.edgeInsets = self.edgeInsets;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
