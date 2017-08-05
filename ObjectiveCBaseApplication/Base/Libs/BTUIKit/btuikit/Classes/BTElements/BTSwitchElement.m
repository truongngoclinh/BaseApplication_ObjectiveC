//
//  BTSwitchElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTSwitchElement.h"

#import "BTElementCell.h"

@implementation BTSwitchElement

- (id)initWithTitle:(NSString *)title image:(UIImage *)image switchOn:(BOOL)isOn
{
    self = [super initWithTitle:title image:image];

    if (self) {
        self.isOn = isOn;
    }

    return self;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    BTElementCell *cell = [super cellForTableView:tableView];

    if (!self.hideSwitch) {
        UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchControl.on = self.isOn;
        [switchControl addTarget:self action:@selector(didChangeSwitchValue:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchControl;
        cell.selectionStyle = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryView = nil;
    }

    return cell;
}

- (void)didChangeSwitchValue:(UISwitch *)sender
{
    // This delegate can fire multiple times even though switch is not toggled.
    if (sender.isOn == self.isOn) {
        return;
    }

    self.isOn = !self.isOn;
    if ([self.accessoryTarget respondsToSelector:self.accessorySelector]) {
        IMP imp = [self.accessoryTarget methodForSelector:self.accessorySelector];
        void (*func)(id, SEL,id) = (void *)imp;
        func(self.accessoryTarget, self.accessorySelector,self);
    }
}

@end
