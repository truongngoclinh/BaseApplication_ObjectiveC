//
//  BTPageHost.h
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BTPagedScrollView, BTPageView;

@interface BTPageHost : NSObject

/*
 Class of page view this host will create
 viewClass must subclass from BTPageView
 */
+ (Class)viewClass;

/*
 Create and configure a page view for scrollable view
 Reuse recycled page views if possible.
 If no recycled page view is available, create a new page
 */
- (BTPageView *)viewForScrollableView:(BTPagedScrollView *)view;

/*
 Recycle view
 */
- (void)recycleView:(BTPageView *)view;

@end
