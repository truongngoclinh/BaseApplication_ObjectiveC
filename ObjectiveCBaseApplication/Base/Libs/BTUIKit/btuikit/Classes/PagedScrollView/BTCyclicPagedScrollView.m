//
//  BTCyclicPagedScrollView.m
//  btuikit
//
//  Created by Ziwei Peng on 27/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTCyclicPagedScrollView.h"

@implementation BTCyclicPagedScrollView

- (instancetype)initWithFrame:(CGRect)frame adjacentViewToPrepare:(NSInteger)count
{
    self = [super initWithFrame:frame adjacentViewToPrepare:count];
    if (self) {
        self.defaultHostIndex = 1;
    }
    return self;
}

- (NSInteger)numOfPages
{
    if (self.pageHosts.count < 2){
        return self.pageHosts.count;
    }

    return self.pageHosts.count + 2;
}

- (NSInteger)hostIndexForPageIndex:(NSInteger)page
{
    if (page == 0) {
        return self.pageHosts.count - 1;
    } else if (page == self.numOfPages - 1) {
        return 0;
    } else {
        return page - 1;
    }
}

- (BTPageHost *)hostForPage:(NSInteger)page
{
    NSInteger index = [self hostIndexForPageIndex:page];
    if (index < self.pageHosts.count){
        return [self.pageHosts objectAtIndex:index];
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];

    if (scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width) {
        [self shiftConetentOffsetIfNeed];
    }
}

- (void)shiftConetentOffsetIfNeed
{
    NSInteger page = (self.innerScrollView.contentOffset.x + self.innerScrollView.frame.size.width / 2) / self.innerScrollView.frame.size.width;

    if (page == self.numOfPages - 1) {
        [self scrollToPage:1];
    } else if (page == 0) {
        [self scrollToPage:self.numOfPages - 2];
    }
}

@end
