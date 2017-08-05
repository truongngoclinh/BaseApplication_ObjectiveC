//
//  BTPageView.h
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTPageHost;

@interface BTPageView : UIView

@property (nonatomic, weak) BTPageHost *host;

/*
 Wheather the scroll view should cancel touch event that is already listened to by view.
 This is useful when the view is kind of button and the event is initially recognized as a touch
 but later becomes a swipe.
 @params view   The view that is listening to the touch event
 @return YES if the event is scroll event and the view should no longer listen to this event
 */
- (BOOL)shouldCancelTouchesInViewWhenScroll:(UIView *)view;

/* 
 Called when view is shown
 */
- (void)viewDidShow;
/*
 Called when view is hidden
 */
- (void)viewDidHide;

/* 
 Called when view is being reused (reconfiguration should be done here)
 */
- (void)willBeReused;
/*
 Called when view is recycled (clean-up should be done here)
 */
- (void)willBeRecycled;

@end
