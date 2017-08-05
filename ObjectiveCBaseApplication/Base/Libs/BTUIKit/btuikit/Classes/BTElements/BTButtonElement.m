//
//  BTButtonElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTButtonElement.h"

#import "BTElementCell.h"

@interface BTButtonElement ()

@end

@implementation BTButtonElement

- (Class)cellClass
{
    return [BTButtonElementCell class];
}

- (BTElementCell *)cellForTableView:(UITableView *)tableView
{
    BTButtonElementCell *cell = (BTButtonElementCell *)[super cellForTableView:tableView];

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.needCenterText = self.needCenterText;

    return cell;
}

@end

@interface BTButtonElementCell()

@property (nonatomic, strong) UILabel *test;

@end

@implementation BTButtonElementCell

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.needCenterText) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, 44);
        self.textLabel.frame = self.contentView.bounds;
    }
}

@end
