//
//  UIView+BTAdditions.h
//  BeeTalk
//
//  Created by garena on 25/2/14.
//  Copyright (c) 2014 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, BTViewAnimationDirection) {

    BTAnimateInTopToBottom = 0,
    BTAnimateOutBottomToTop = 1,
    BTAnimateInBottomToTop = 2,
    BTAnimateOutTopToBottom = 3,
};

@interface UIView (BTFoundation)

/*
Notes that all centering method require the view to have been already added to its superview
*/

/**
Centers view both horizontally and vertically
*/
- (void)bt_centerWithWidth:(CGFloat)width height:(CGFloat)height;

- (void)bt_centerHorizontallyWithTopPadding:(CGFloat)topPadding size:(CGSize)size;
- (void)bt_centerHorizontallyWithTopPadding:(CGFloat)topPadding width:(CGFloat)width height:(CGFloat)height;
/**
Centers the view horizontally with a fixed horizontal padding on both edges and flexible width
*/
- (void)bt_centerHorizontallyWithXPadding:(CGFloat)xPadding topPadding:(CGFloat)topPadding height:(CGFloat)height;

- (void)bt_centerVerticallyWithLeftPadding:(CGFloat)leftPadding size:(CGSize)size;
- (void)bt_centerVerticallyWithLeftPadding:(CGFloat)leftPadding width:(CGFloat)width height:(CGFloat)height;
- (void)bt_centerVerticallyWithRightPadding:(CGFloat)rightPadding size:(CGSize)size;


/*
Allows frame of the view to be set directly
*/
- (void)bt_setFrameX:(CGFloat)x;
- (void)bt_setFrameY:(CGFloat)y;
- (void)bt_setFrameWidth:(CGFloat)width;
- (void)bt_setFrameHeight:(CGFloat)height;

/**
Calls sizeThatsFits with maximum width and height
*/
- (CGSize)bt_sizeRequired;

/**
Calls sizeThatsFits with maximum height
*/
- (CGSize)bt_sizeThatFitsWidth:(CGFloat)width;

/**
Provides a sliding animation from top or from botttom
Only call after the frame of view has been set.
*/
- (void)bt_animateSlide:(BTViewAnimationDirection)direction
        animatations:(dispatch_block_t)animatations
          completion:(void (^)(BOOL finished))completion;

@end
