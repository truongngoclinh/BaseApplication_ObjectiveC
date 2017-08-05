//
//  BTElement.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BTElementCell.h"

typedef NS_OPTIONS(NSInteger,BTElementSelectionStyle)
{
    BTElementSelectionStyleDefault = 0,
    BTElementSelectionStyleHighlight = 1,
    BTElementSelectionStyleNoHighight = 2
};

typedef NS_OPTIONS(NSInteger, BTElementBorderStyle)
{
    BTElementBorderStyleDefault = 0,
    BTElementBorderStyleNone = 1,
    BTElementBorderStyleTopOnly = 2,
    BTElementBorderStyleBottomOnly = 3,
    BTElementBorderStyleBoth = 4,
};

typedef void(^BTElementOnCommitEditingStyleBlock)(UITableViewCellEditingStyle editingStyle);

@protocol BTElementDynamicHeight <NSObject>

- (CGFloat)requiredHeightForWidth:(CGFloat)width;

@end

@class BTElement, BTRootElement, BTElementCell;

@interface BTElement : NSObject

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, weak) BTRootElement *rootElement;

@property (nonatomic, strong) NSString *key;

/**
Convenience property to set the height of the element. Instead of subclassing and implement requiredHeightForWidth
If requiredHeightForWidth is implemented, it takes precedence over this property.
*/
@property (nonatomic, assign) CGFloat height;

- (BTElement *)elementAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForTableView:(UITableView *)tableView;

// Subclass override
- (NSString *)identifier;
- (BTElementCell *)cellForTableView:(UITableView *)tableView;
- (void)selectedCellForTableView:(UITableView *)tableView;

- (void)addTarget:(id)target selector:(SEL)selector;
- (void)addAccessoryTarget:(id)target selector:(SEL)selector;

- (Class)cellClass;

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) id accessoryTarget;
@property (nonatomic, assign) SEL accessorySelector;

//Customise border style
@property (nonatomic, assign) BTElementBorderStyle borderStyle;
@property (nonatomic, assign) CGFloat bottomBorderLeftPadding;
@property (nonatomic, assign) CGFloat bottomBorderRightPadding;

//Selection Style
/**
Default behaviour is to check for self.target
*/
@property (nonatomic, assign) BTElementSelectionStyle selectionStyle;

//Editing Support
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) NSString *deleteBtnTitle;
@property (nonatomic, strong) BTElementOnCommitEditingStyleBlock onCommitEditingStyle;

//Expansion Support
@property (nonatomic, strong) NSArray *children;
// Use Boolean flag to indicate wheather current element is expanded
// so calculating no. of rows is faster
@property (nonatomic, assign) BOOL isChildrenActive;
@property (nonatomic, weak) BTElement *parent;

@property (nonatomic, assign) CGFloat expandedBottomBorderLeftPadding;

/*
Default behaviour is to toggle expansion on selection. Set NO to override this behaviour
**/
@property (nonatomic, assign) BOOL disableToggleExpandOnSelection;
/*
Default behaviour is to animate expansion/collapse on selection. Set NO to override this behaviour
**/
@property (nonatomic, assign) BOOL disableAnimateToggleOnSelection;
/*
Default animation is UITableViewRowAnimationNone
**/
@property (nonatomic, assign) UITableViewRowAnimation expansionAnimation;

- (BOOL)isChildren;
- (BOOL)isLastChildren;
- (void)expandChildren:(UITableView *)tableView animated:(BOOL)animated;
- (void)collapseChildren:(UITableView *)tableView animated:(BOOL)animated;
- (void)toggleExpansion:(UITableView *)tableView animated:(BOOL)animated;

// Used to restore collapse state
- (NSIndexPath *)indexPathIgnoringCollapsibleForTableView:(UITableView *)tableView;
- (NSString *)identifierIgnoringCollapsibleForTableView:(UITableView *)tableView;

@end
