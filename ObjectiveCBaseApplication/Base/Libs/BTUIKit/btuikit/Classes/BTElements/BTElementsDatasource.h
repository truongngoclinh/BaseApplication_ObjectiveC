//
//  BTElementsDatasource.h
//  btuikit
//
//  Created by garena on 21/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BTRootElement.h"

@class BTElementsDatasource;

typedef void(^BTElementsDatasourceBuildBlock)(BTRootElement *rootElement);
typedef BTElementBorderStyle(^BTElementsDatasourceConfigBorderBlock)(NSIndexPath *indexPath);
typedef CGFloat(^BTElementsDatasourceConfigSectionPaddingBlock)(NSInteger sectionPadding);

@interface BTElementsDatasource : NSObject <UITableViewDataSource,UITableViewDelegate>

/**
Will relay all scrollview events to this delegate
*/
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollViewDelegate;

@property (nonatomic, strong, readonly) BTRootElement *rootElement;

@property (nonatomic, strong) BTElementsDatasourceBuildBlock buildBlock;

@property (nonatomic, weak, readonly) UITableView *tableView;

/**
Sets the default cell height of elements that do not have height explicity stated.
Fallback to 44 if this value is not set.
*/
@property (nonatomic, assign) CGFloat defaultCellHeight;

/**
For expanded elements, there will be a left padding for the cell borders.
Set 0 to have normal cell borders
*/
@property (nonatomic, assign) CGFloat bottomBorderLeftPaddingForExpandedElements;

/**
Configuration block to customsize whether to show cell borders for a indexPath.
Block param is NSIndexPath
Block return is BOOL (whether show cellBorders)
Note that there are 2 ways to show/hide cell borders. Another way is setting the property on the element itself,which takes priority.
*/
@property (nonatomic, strong) BTElementsDatasourceConfigBorderBlock configCellBordersBlock;

/**
Configuration block to customsize the bottom padding of each section
Block param is NSInteger - section
Block return is CGFloat - bottomPadding
*/
@property (nonatomic, strong) BTElementsDatasourceConfigSectionPaddingBlock configSectionPaddingBlock;

/**
 For automatically deselect cell after selection
 */
@property (nonatomic, assign) BOOL shouldAutoDeselectRowAfterSelection;

- (instancetype)initWithTableView:(UITableView *)tableView buildBlock:(BTElementsDatasourceBuildBlock)buildBlock;

/**
Run the buildblock. Remember to call this method or refresh method on ViewDidLoad
*/
- (void)buildElements;
/**
Call buildElements and [tableView reloadData]
*/
- (void)refresh;

//Expansion support
- (void)collapseAll:(BOOL)animated;
- (void)expandAll:(BOOL)animated;
- (BOOL)hasElementsWithChildren;

@end

//Have to make this a subclass to support editing.
//See comments on commitEditingStyle method
@interface BTEditableElementsDatasource : BTElementsDatasource

@end
