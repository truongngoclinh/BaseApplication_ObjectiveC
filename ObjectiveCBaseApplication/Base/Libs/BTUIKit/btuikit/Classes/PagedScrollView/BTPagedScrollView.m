//
//  BTPagedSrollableView.m
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTPagedScrollView.h"

#import "BTPageHost.h"
#import "BTPageView.h"

@interface BTPagedScrollViewInnerView : UIScrollView

@property (nonatomic, weak) BTPagedScrollView *touchCancelDelegate;

@end

@implementation BTPagedScrollViewInnerView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if (self.touchCancelDelegate) {
        return [self.touchCancelDelegate scrollViewShouldCancelTouchesInView:view];
    }

    return NO;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    if (delegate && ![delegate isKindOfClass:[BTPagedScrollView class]]) {
        NSLog(@"%@ Error: the delegate of inner scroll view must be kind of BTPagedScrollView!\n Setting delegate ignored.", [BTPagedScrollView class]);
        return;
    } else {
        [super setDelegate:delegate];
    }
}

@end

@interface BTPagedScrollView () {
    BTPagedScrollViewInnerView *innerScrollView;
}

@property (nonatomic, strong) NSMutableDictionary *activePages;
@property (nonatomic, strong) NSMutableArray *recycledPages;

- (BOOL)scrollViewShouldCancelTouchesInView:(UIView *)view;

@end

@implementation BTPagedScrollView

@synthesize innerScrollView = innerScrollView;

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame adjacentViewToPrepare:1];
}

- (id)initWithFrame:(CGRect)frame adjacentViewToPrepare:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        innerScrollView = [[BTPagedScrollViewInnerView alloc] initWithFrame:frame];
        innerScrollView.pagingEnabled = YES;
        innerScrollView.delegate = self;
        innerScrollView.touchCancelDelegate = self;
        innerScrollView.showsHorizontalScrollIndicator = NO;
        innerScrollView.canCancelContentTouches = YES;
        innerScrollView.delaysContentTouches = NO;
        [self addSubview:innerScrollView];

        self.activePages = [NSMutableDictionary dictionaryWithCapacity:5];
        self.recycledPages = [NSMutableArray arrayWithCapacity:5];

        _adjacentViewToPrepare = count;

        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setDefaultHostIndex:(NSInteger)defaultHostIndex
{
    _defaultHostIndex = defaultHostIndex;
    self.currentPageIndex = defaultHostIndex;

    [self scrollToPage:defaultHostIndex];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    BTPageView *prevView = [self currentPage];
    [prevView viewDidHide];

    _currentPageIndex = currentPageIndex;

    [self recycleExpiredViewsAtCurrentPage:currentPageIndex];
    [self prepareAdjacentPagesAtCurrentPage:currentPageIndex];

    BTPageView *currentView = [self currentPage];
    [currentView viewDidShow];
}

- (void)setPageHosts:(NSArray *)pageHosts
{
    _pageHosts = pageHosts;

    innerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * self.numOfPages, CGRectGetHeight(self.bounds));

    [self reload];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    // Scroll to the content offset immediately after setting frame
    NSInteger currentPage = (innerScrollView.contentOffset.x + innerScrollView.frame.size.width / 2) / innerScrollView.frame.size.width;
    innerScrollView.frame = self.bounds;
    [self scrollToPage:currentPage];

    innerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * self.numOfPages, CGRectGetHeight(self.bounds));
    [self reload];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.activePages enumerateKeysAndObjectsUsingBlock:^(NSNumber *pageIndex, BTPageView *page, BOOL *stop) {
        [self adjustFrameForPageAt:[pageIndex integerValue]];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    if (newSuperview) {
        [self reload];
    }
}

- (void)reload
{
    if (self.pageHosts == nil) {
        return;
    }

    self.currentPageIndex = MIN(self.currentPageIndex, self.pageHosts.count);

    [self scrollToPage:self.currentPageIndex];
}

- (BTPageHost *)currentPageHost
{
    return [self hostForPage:self.currentPageIndex];
}

- (BTPageView *)currentPage
{
    return [self.activePages objectForKey:@(self.currentPageIndex)];
}

- (NSDictionary *)activePages
{
    return [_activePages copy];
}

- (NSInteger)recycledPageCount
{
    return [self.recycledPages count];
}

- (void)scrollToPage:(NSInteger)page
{
    [self scrollToPage:page animated:NO];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    [innerScrollView scrollRectToVisible:CGRectMake(page * CGRectGetWidth(innerScrollView.frame), 0,
                                                    CGRectGetWidth(innerScrollView.frame), CGRectGetHeight(innerScrollView.frame))
                                animated:animated];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width;

    if (page < 0 || page >= self.numOfPages) {
        return;
    }

    if (self.currentPageIndex != page) {
        self.currentPageIndex = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width;

    if (page < 0 || page >= self.numOfPages) {
        return;
    }

    if (self.currentPageIndex != page) {
        self.currentPageIndex = page;
    }
}

- (void)adjustFrameForPageAt:(NSInteger)page
{
    BTPageView *resultView = [self.activePages objectForKey:@(page)];
    if (resultView == nil) {
        return;
    }
    CGRect frame = CGRectMake(innerScrollView.frame.size.width*page,
                              0,
                              innerScrollView.frame.size.width,
                              innerScrollView.frame.size.height);
    resultView.frame = UIEdgeInsetsInsetRect(frame, self.insets);
}

- (BTPageHost *)hostForPage:(NSInteger)page
{
    if (page < self.pageHosts.count){
        return [self.pageHosts objectAtIndex:page];
    }
    return nil;
}

- (NSInteger)numOfPages
{
    return self.pageHosts.count;
}

- (void)prepareAdjacentPagesAtCurrentPage:(NSInteger)page
{
    if (self.pageHosts == nil) {
        return;
    }

    NSInteger minPage = MAX(0, (page-self.adjacentViewToPrepare));
    NSInteger maxPage = MIN(self.numOfPages-1, page+self.adjacentViewToPrepare);

    for (NSInteger i = minPage; i <= maxPage; i++) {

        BOOL hasActive = [self hasActiveViewAtCurrentPage:i];

        if (!hasActive) {
            BTPageHost *host = [self hostForPage:i];
            if (host == nil) {
                return;
            }

            BTPageView *resultView = [host viewForScrollableView:self];

            //set ScrollView details
            [_activePages setObject:resultView forKey:@(i)];
            resultView.hidden = NO;
            [innerScrollView addSubview:resultView];

            [self adjustFrameForPageAt:i];
        }
    }

//    NSLog(@"%@[%@] %@ current active pages: %@", [self class], self, NSStringFromSelector(_cmd), self.activePages);

    NSParameterAssert(self.activePages.allKeys.count <= self.adjacentViewToPrepare * 2 + 1);
}

- (BOOL)hasActiveViewAtCurrentPage:(NSInteger)page
{
    UIView *view = [self.activePages objectForKey:@(page)];

    return view != nil;
}

- (BTPageView *)dequeueResultsView
{
    BTPageView *view = [self.recycledPages lastObject];

    if (view != nil) {
        [self.recycledPages removeObject:view];
    }

    return view;
}

- (void)recycleExpiredViewsAtCurrentPage:(NSInteger)page
{
    NSArray *keys = [self.activePages allKeys];

    NSMutableArray *expiredKeys = [NSMutableArray arrayWithCapacity:keys.count];

    for (NSNumber *key in keys) {
        NSInteger diff = ABS([key integerValue] - page);

        if (diff > self.adjacentViewToPrepare) {
            [expiredKeys addObject:key];
        }
    }

    for (NSNumber *key in expiredKeys) {
        BTPageView *view = [self.activePages objectForKey:key];
        BTPageHost *host = [self hostForPage:[key integerValue]];
        if (host != nil){
            [host recycleView:view];
        }else{
            [view willBeRecycled];
        }

        [_activePages removeObjectForKey:key];
        [self recycleResultsView:view];
    }

//    NSLog(@"%@[%@] %@ current active pages: %@", [self class], self, NSStringFromSelector(_cmd), self.activePages);
}

- (void)recycleResultsView:(BTPageView *)resultsView
{
    [resultsView removeFromSuperview];
    [self.recycledPages addObject:resultsView];
}

- (BOOL)scrollViewShouldCancelTouchesInView:(UIView *)view
{
    return [self.currentPage shouldCancelTouchesInViewWhenScroll:view];
}

@end
