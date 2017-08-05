//
//  BTPagedSrollableView.h
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTPageHost, BTPageView;

/**
 Implement a UIView containing a paged scroll view
 */
@interface BTPagedScrollView : UIView <UIScrollViewDelegate>

/**
 An array of BTPageHost objects, each representing a page
 */
@property (nonatomic, strong) NSArray *pageHosts;

/**
 Default index of host, default is 0
 */
@property (nonatomic, assign) NSInteger defaultHostIndex;

/*
 Inset of current showing page
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 The index of current showing page.
 It can be different from the index of host for current showing page
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

/**
 The inner scroll view
 */
@property (nonatomic, strong, readonly) UIScrollView *innerScrollView;

/**
 The number of adjacent views to prepare for showing.
 There will be 2*adjacentViewToPrepare at most pages prepared,
 in addition to the current page.
 Default set to 1.
 */
@property (nonatomic, assign) NSInteger adjacentViewToPrepare;

/**
 Initialize with given frame, with ajdacentViewToPrepare being 1.
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 Initialize with given frame and adjacentViewToPrepare.
 @params frame  frame of the BTPagedScrollView
 @params count  the number of adjacent views to prepare, from both left and right to the current view
 */
- (instancetype)initWithFrame:(CGRect)frame adjacentViewToPrepare:(NSInteger)count;

/**
 The host for current page
 */
- (BTPageHost *)currentPageHost;

/**
 Current showing page
 */
- (BTPageView *)currentPage;

/**
 Dequeue a recycled page
 */
- (BTPageView *)dequeueResultsView;

/**
 Find the host for the page index
 @params page the index of the page
 @return the host for page
 */
- (BTPageHost *)hostForPage:(NSInteger)page;
/**
 The total number of pages
 */
- (NSInteger)numOfPages;

/**
 Find the current loaded pages, including the current showing page, and the adjacent pages.
 Every page is associated with their page index
 */
- (NSDictionary *)activePages;
/**
 Return the number of recycled pages
 */
- (NSInteger)recycledPageCount;

/**
 Scroll the inner scroll view to page, without animation
 */
- (void)scrollToPage:(NSInteger)page;

/**
 Scroll the inner scroll view to page
 */
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

/*
 Wheather the scroll view should cancel touch event that is already listened to by view.
 This is useful when the view is kind of button and the event is initially recognized as a touch
 but later becomes a swipe.
 @params view   The view that is listening to the touch event
 @return YES if the event is scroll event and the view should no longer listen to this event
 */
- (BOOL)scrollViewShouldCancelTouchesInView:(UIView *)view;

@end
