//
//  BTPageHost.m
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTPageHost.h"

#import "BTPagedScrollView.h"
#import "BTPageView.h"

@implementation BTPageHost

+ (Class)viewClass
{
    return [BTPageView class];
}

- (BTPageView *)viewForScrollableView:(BTPagedScrollView *)view
{
    BTPageView *pageView = [view dequeueResultsView];
    BOOL isNew = pageView == nil;
    if (pageView == nil) {
        pageView = [[[[self class] viewClass] alloc] initWithFrame:CGRectZero];
    }

    pageView.host = self;

    if (! isNew) {
        [pageView willBeReused];
    }

    return pageView;
}

- (void)recycleView:(BTPageView *)view
{
    [view willBeRecycled];
}

@end
