//
//  BTElementsDatasource.m
//  btuikit
//
//  Created by garena on 21/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTElementsDatasource.h"
#import "BTSectionElement.h"

static const CGFloat kDefaultCellHeight = 44;
static const CGFloat kSectionPadding = 25;
static const CGFloat kDefaultBottomBorderLeftPaddingForExpandedElements = 50;

@interface BTElementsDatasource()

@property (nonatomic, weak) UITableView *tableView; //Weak reference to tableview
@property (nonatomic, strong, readwrite) BTRootElement *rootElement;

//@property (nonatomic, assign) CGPoint previousContentOffset;

@end

@implementation BTElementsDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultCellHeight = -1;
        _bottomBorderLeftPaddingForExpandedElements = -1;
        self.rootElement = [BTRootElement new];
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView buildBlock:(BTElementsDatasourceBuildBlock)buildBlock
{
    self = [self init];
    if (self) {
        self.tableView = tableView;
        self.buildBlock = buildBlock;
    }
    return self;
}

- (void)buildElements
{
    self.buildBlock(self.rootElement);
}

- (void)refresh
{
    if ([self hasElementsWithChildren]) {
        [self refreshPreservingExpansion];
        return;
    }

    [self buildElements];
    [self.tableView reloadData];
}

- (BOOL)hasElementsWithChildren
{
    __block BOOL found = NO;
    [self.rootElement.sections enumerateObjectsUsingBlock:^(BTSectionElement *sectionElement, NSUInteger idx, BOOL *stop) {
        [sectionElement.rows enumerateObjectsUsingBlock:^(BTElement *rowElement, NSUInteger idx, BOOL *stop) {
            if (rowElement.children) {
                found = YES;
                *stop = YES;
            }
        }];
    }];

    return found;
}

- (void)refreshPreservingExpansion
{
    CGPoint originalOffset = self.tableView.contentOffset;

    __block NSMutableDictionary *elementExpansionDict = [NSMutableDictionary dictionary];

    // Save expanded state
    [self.rootElement.sections enumerateObjectsUsingBlock:^(BTSectionElement *sectionElement, NSUInteger idx, BOOL *stop) {

        [sectionElement.rows enumerateObjectsUsingBlock:^(BTElement *rowElement, NSUInteger idx, BOOL *stop) {

            if (rowElement.children) {
                elementExpansionDict[[rowElement identifierIgnoringCollapsibleForTableView:self.tableView]] = @(rowElement.isChildrenActive);
            }

        }];

    }];

    // Rebuild cells
    [self buildElements];

    // Expand cells again
    __block NSMutableArray *cellsToExpand = [NSMutableArray array];

    [self.rootElement.sections enumerateObjectsUsingBlock:^(BTSectionElement *sectionElement, NSUInteger idx, BOOL *stop) {

        [sectionElement.rows enumerateObjectsUsingBlock:^(BTElement *rowElement, NSUInteger idx, BOOL *stop) {

            if (rowElement.children) {
                if ([elementExpansionDict[[rowElement identifierIgnoringCollapsibleForTableView:self.tableView]] integerValue] > 0) {
                    [cellsToExpand addObject:rowElement];
                }
            }

        }];
    }];

    [self expandElements:cellsToExpand animated:NO];
    [self.tableView reloadData];

    self.tableView.contentOffset = originalOffset;
}

- (CGFloat)paddingForSection:(NSInteger)section
{
    BTSectionElement *sectionElement = (BTSectionElement *)self.rootElement.sections[section];
    if (sectionElement.bottomPadding != BTSectionElementBottomPaddingNotSet) {
        return sectionElement.bottomPadding;
    }

    if (self.configSectionPaddingBlock) {
        return self.configSectionPaddingBlock(section);
    }

    return kSectionPadding;
}

- (CGFloat)defaultCellHeight
{
    if (_defaultCellHeight != -1) {
        return _defaultCellHeight;
    }

    return kDefaultCellHeight;
}

- (BTElementBorderStyle)cellBorderStyleForIndexPath:(NSIndexPath *)indexPath
{
    if (self.configCellBordersBlock) {
        return self.configCellBordersBlock(indexPath);
    }

    return BTElementBorderStyleDefault;
}

- (BOOL)needBottomBorderLeftPaddingForElement:(BTElement *)element
{
    if (element.isChildrenActive) {
        return YES;
    }

    if (element.isChildren && !element.isLastChildren) {
        return YES;
    }

    return NO;
}

- (CGFloat)bottomBorderLeftPaddingForExpandedElements
{
    if (_bottomBorderLeftPaddingForExpandedElements != -1) {
        return _bottomBorderLeftPaddingForExpandedElements;
    }

    return kDefaultBottomBorderLeftPaddingForExpandedElements;
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rootElement numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rootElement numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTElement *element = [self.rootElement elementAtIndexPath:indexPath];

    if ([element conformsToProtocol:@protocol(BTElementDynamicHeight)]) {
        id<BTElementDynamicHeight> dynamicElement = (id<BTElementDynamicHeight>)element;
        return [dynamicElement requiredHeightForWidth:CGRectGetWidth(tableView.bounds)];
    }

    if (element.height) {
        return element.height;
    }

    return [self defaultCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTElement *element = [self.rootElement elementAtIndexPath:indexPath];

    BTElementCell *cell = [element cellForTableView:tableView];

    //Check border style of element first. It takes priority over the the delegate method.
    BTElementBorderStyle borderStyle = element.borderStyle;

    //If borderStyle of element is not set or set to default, try getting it from the delegate method
    if (borderStyle == BTElementBorderStyleDefault) {
        borderStyle = [self cellBorderStyleForIndexPath:indexPath];
    }

    if (borderStyle == BTElementBorderStyleDefault) {
        BOOL isFirstCell = (indexPath.row == 0);
        cell.showTopBorder = isFirstCell;
        cell.showBottomBorder = YES;

    } else {
        cell.showTopBorder = (borderStyle == BTElementBorderStyleTopOnly || borderStyle == BTElementBorderStyleBoth);
        cell.showBottomBorder = (borderStyle == BTElementBorderStyleBottomOnly || borderStyle == BTElementBorderStyleBoth);
    }

    if ([self needBottomBorderLeftPaddingForElement:element]) {
        //Follow table defaults
        if (element.expandedBottomBorderLeftPadding != -1) {
            cell.bottomBorderLeftPadding = element.expandedBottomBorderLeftPadding;
        } else {
            cell.bottomBorderLeftPadding = [self bottomBorderLeftPaddingForExpandedElements];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTElement *element = [self.rootElement elementAtIndexPath:indexPath];

    [element selectedCellForTableView:tableView];
    
    if (self.shouldAutoDeselectRowAfterSelection) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.rootElement titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self.rootElement titleForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BTSectionElement *sectionElement = [self.rootElement.sections objectAtIndex:section];
    return [sectionElement heightForHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //If there is a custom footer, use its height
    BTSectionElement *sectionElement = [self.rootElement.sections objectAtIndex:section];
    if (sectionElement.footerView) {
        return [sectionElement heightForFooter];
    }

    //Use the default padding between sections
    return [self paddingForSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BTSectionElement *sectionElement = [self.rootElement.sections objectAtIndex:section];
    return [sectionElement headerView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //Check for custom footerView first
    //Make sure that your custom footerView has a height
    BTSectionElement *sectionElement = [self.rootElement.sections objectAtIndex:section];
    if (sectionElement.footerView) {
        return sectionElement.footerView;
    }

    //Create a empty footer view just to create space between sections
    UIView *view;
    if ([tableView respondsToSelector:@selector(dequeueReusableHeaderFooterViewWithIdentifier:)]) {

        static NSString *identifier = @"emptyFooter";
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];

        if (view == nil) {
            UITableViewHeaderFooterView *headerFooterView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
            headerFooterView.backgroundView = [[UIView alloc] init];
            view = headerFooterView;
        }
    } else {
        view = [[UIView alloc] init];
    }

    return view;
}

#pragma mark Elements Expansion/Collapse Support

- (void)expandElements:(NSArray *)elements animated:(BOOL)animated
{
    [elements enumerateObjectsUsingBlock:^(BTElement *element, NSUInteger idx, BOOL *stop) {
        [element expandChildren:self.tableView animated:animated];
    }];
}

- (void)collapseElements:(NSArray *)elements animated:(BOOL)animated
{
    [elements enumerateObjectsUsingBlock:^(BTElement *element, NSUInteger idx, BOOL *stop) {
        [element collapseChildren:self.tableView animated:animated];
    }];
}

- (void)expandAll:(BOOL)animated
{
    [self expandOrCollapseAll:YES animated:animated];
}

- (void)collapseAll:(BOOL)animated
{
    [self expandOrCollapseAll:NO animated:animated];
}

- (void)expandOrCollapseAll:(BOOL)isExpand animated:(BOOL)animated
{
    __block NSMutableArray *elements = [NSMutableArray array];
    [self.rootElement.sections enumerateObjectsUsingBlock:^(BTSectionElement *sectionElement, NSUInteger idx, BOOL *stop) {

        [sectionElement.rows enumerateObjectsUsingBlock:^(BTElement *rowElement, NSUInteger idx, BOOL *stop) {

            if (rowElement.children) {
                [elements addObject:rowElement];
            }

        }];
    }];

    if (isExpand) {
        [self expandElements:elements animated:animated];
    } else {
        [self collapseElements:elements animated:animated];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.scrollViewDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.scrollViewDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.scrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.scrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.scrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}

@end

@implementation BTEditableElementsDatasource

#pragma mark Editing Support

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTElement *element = [self.rootElement elementAtIndexPath:indexPath];
    return element.canEdit;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTElement *element = [self.rootElement elementAtIndexPath:indexPath];
    return element.deleteBtnTitle;
}

//If this method is implemented, cell can be swipable if canEditRowAtIndexPath is YES.
//However, there are cases where we need the editing but do not need the swiping
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTElement *element = [self.rootElement elementAtIndexPath:indexPath];
    if (element.onCommitEditingStyle) {
        element.onCommitEditingStyle(editingStyle);
    }
}

@end
