//
//  BTElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTUIKitDefines.h"
#import "BTElement.h"

#import "BTElementCell.h"

#import "BTRootElement.h"
#import "BTSectionElement.h"

@implementation BTElement

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.expandedBottomBorderLeftPadding = -1;
        self.expansionAnimation = UITableViewRowAnimationNone;
    }
    return self;
}

- (BTElement *)elementAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.rootElement);
    BTSectionElement *sectionElement = self.rootElement.sections[indexPath.section];

    // Faster iteration
    NSInteger count = 0;
    for (NSInteger i = 0; i < sectionElement.rows.count; i++) {
        BTElement *rowElement = [sectionElement.rows objectAtIndex:i];
        if (count == indexPath.row) {
            return rowElement;
        } else if (! rowElement.isChildrenActive) {
            count += 1;
        } else if (count + 1 + rowElement.children.count <= indexPath.row) {
            count += 1 + rowElement.children.count;
        } else {
            return [rowElement.children objectAtIndex:(indexPath.row - count - 1)];
        }
    }
    return nil;
}

- (void)addAccessoryTarget:(id)target selector:(SEL)selector
{
    self.accessoryTarget = target;
    self.accessorySelector = selector;
}

- (void)addTarget:(id)target selector:(SEL)selector
{
    self.target = target;
    self.selector = selector;
}

- (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

-(Class)cellClass
{
    return [BTElementCell class];
}

static inline UITableViewCellSelectionStyle defaultSelectionStyle() {

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return UITableViewCellSelectionStyleDefault;
    } else {
        return UITableViewCellSelectionStyleBlue;
    }
}

- (BTElementCell *)cellForTableView:(UITableView *)tableView
{
    BTElementCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    
    if (cell == nil) {
        cell = [[[self cellClass] alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:self.identifier];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;

    if (self.hasNextPage) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryView = nil;
    }

    if (self.selectionStyle == BTElementSelectionStyleDefault) {
        cell.selectionStyle = self.target ? defaultSelectionStyle() : UITableViewCellSelectionStyleNone;
    } else if (self.selectionStyle == BTElementSelectionStyleHighlight) {
        cell.selectionStyle = defaultSelectionStyle();
    } else if (self.selectionStyle == BTElementSelectionStyleNoHighight) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.bottomBorderLeftPadding = self.bottomBorderLeftPadding;
    cell.bottomBorderRightPadding = self.bottomBorderRightPadding;

    cell.accessibilityLabel = self.accessibilityLabel;

    // TODO : Sometimes the accessibility label of cell's accessory view is wrong
    // i.e. UISwitch of BTSwitchElement has accessibily label being "expand all"
    // Hack for KIF testing only
    cell.accessibilityValue = self.accessibilityLabel;

    return cell;
}

- (NSIndexPath *)indexPathForTableView:(UITableView *)tableView
{
    NSParameterAssert(self.rootElement);
    for (int i=0;i<self.rootElement.sections.count;i++) {
        BTSectionElement *element = self.rootElement.sections[i];

        NSUInteger row = 0;
        for (int j = 0; j < element.rows.count; j++) {
            BTElement *rowElement = element.rows[j];

            if ([self isEqual:rowElement]) {
                return [NSIndexPath indexPathForRow:row inSection:i];

            } else if (rowElement.isChildrenActive) {

                // Increment row number to account for a row containing the parent
                row++;

                NSUInteger indexOfSelfInChildren = [rowElement.children indexOfObject:self];
                if (indexOfSelfInChildren != NSNotFound) {
                    row = row + indexOfSelfInChildren;
                    return [NSIndexPath indexPathForRow:row inSection:i];

                } else {
                    row += rowElement.children.count;

                }

            } else {
                row++;
            }

        }
    }

    return nil;
}

- (void)selectedCellForTableView:(UITableView *)tableView
{
    if (self.children && !self.disableToggleExpandOnSelection) {
        [self toggleExpansion:tableView animated:!self.disableAnimateToggleOnSelection];
    }

    if ([self.target respondsToSelector:self.selector]) {
        [self.target performSelectorOnMainThread:self.selector withObject:self waitUntilDone:YES];
    }
}

- (void)expandChildren:(UITableView *)tableView animated:(BOOL)animated
{
    if (self.isChildrenActive) {
        return;
    }

    [self toggleExpansion:tableView animated:animated];
}

- (void)collapseChildren:(UITableView *)tableView animated:(BOOL)animated
{
    if (!self.isChildrenActive) {
        return;
    }

    [self toggleExpansion:tableView animated:animated];
}

- (void)toggleExpansion:(UITableView *)tableView animated:(BOOL)animated
{
    if (!animated) {
        self.isChildrenActive = !self.isChildrenActive;
        [tableView reloadData];
        return;
    }

    if (self.children) {

        [tableView beginUpdates];

        NSIndexPath *indexPath = [self indexPathForTableView:tableView];
        NSParameterAssert(indexPath);

        NSMutableArray *deleteRows = [NSMutableArray new];
        NSMutableArray *addedRows = [NSMutableArray new];

        //Collapse all children
        if (self.isChildrenActive) {

            for (int i = 0; i < self.children.count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+i+1 inSection:indexPath.section];
                [deleteRows addObject:path];
            }

            self.isChildrenActive = NO;

            if (animated && deleteRows.count > 0) {
                [tableView deleteRowsAtIndexPaths:deleteRows withRowAnimation:self.expansionAnimation];
            }
        }

        //Expand all children
        else {
            for (int i=0; i<self.children.count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+i+1 inSection:indexPath.section];
                [addedRows addObject:path];
            }

            self.isChildrenActive = YES;

            if (animated && addedRows.count > 0) {
                [tableView insertRowsAtIndexPaths:addedRows withRowAnimation:self.expansionAnimation];
            }
        }

        [tableView endUpdates];
    }
}


- (NSIndexPath *)indexPathIgnoringCollapsibleForTableView:(UITableView *)tableView
{
    NSParameterAssert(self.rootElement);
    for (int i=0;i<self.rootElement.sections.count;i++) {
        BTSectionElement *element = self.rootElement.sections[i];

        NSUInteger row = 0;
        for (int j = 0; j < element.rows.count; j++) {
            BTElement *rowElement = element.rows[j];

            if ([self isEqual:rowElement]) {
                return [NSIndexPath indexPathForRow:row inSection:i];
            } else {
                row++;
            }
            
        }
    }
    
    return nil;
}

- (NSString *)identifierIgnoringCollapsibleForTableView:(UITableView *)tableView
{
    NSIndexPath *indexPath = [self indexPathIgnoringCollapsibleForTableView:tableView];
    if (indexPath) {
        return [NSString stringWithFormat:@"section %ld - row %ld", (long)indexPath.section, (long)indexPath.row];
    }

    return @"child row";
}

- (void)setChildren:(NSArray *)children
{
    _children = children;

    for (BTElement *element in children) {
        element.parent = self;
    }
}

- (BOOL)isChildren
{
    return self.parent != nil;
}

- (BOOL)isLastChildren
{
    return self.parent.children.lastObject == self;
}

@end
