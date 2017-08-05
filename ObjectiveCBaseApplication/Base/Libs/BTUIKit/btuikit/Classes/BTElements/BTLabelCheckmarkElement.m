//
//  BTLabelCheckmarkElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 10/5/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTLabelCheckmarkElement.h"

#import "BTElementCell.h"

@implementation BTLabelCheckmarkElement

- (id)initWithTitle:(NSString *)title checked:(BOOL)isChecked
{
    self = [super initWithTitle:title];
    
    if (self) {
        self.isChecked = isChecked;
    }
    
    return self;
}


- (BTElementCell *)cellForTableView:(UITableView *)tableView
{
    BTElementCell *cell = [super cellForTableView:tableView];
    
    cell.accessoryType = self.isChecked? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

@end
