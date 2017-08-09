//
//  UIView+BTAdditions.m
//  BeeTalk
//
//  Created by garena on 25/2/14.
//  Copyright (c) 2014 Garena. All rights reserved.
//

#import "UIView+BTFoundation.h"

@implementation UIView (BTFoundation)

-(void)bt_centerWithWidth:(CGFloat)width height:(CGFloat)height
{
    self.frame = CGRectMake(self.superview.bounds.size.width/2.0 - width/2.0,
                            self.superview.bounds.size.height/2.0 - height/2.0,
                            width, height);
}

- (void)bt_centerHorizontallyWithTopPadding:(CGFloat)topPadding size:(CGSize)size
{
    [self bt_centerHorizontallyWithTopPadding:topPadding width:size.width height:size.height];
}

- (void)bt_centerHorizontallyWithTopPadding:(CGFloat)topPadding width:(CGFloat)width height:(CGFloat)height
{
    self.frame = CGRectMake(self.superview.bounds.size.width/2.0 - width/2.0,
                            topPadding,
                            width, height);
}

- (void)bt_centerHorizontallyWithXPadding:(CGFloat)xPadding topPadding:(CGFloat)topPadding height:(CGFloat)height
{
    self.frame = CGRectMake(xPadding,
                            topPadding,
                            self.superview.bounds.size.width - (xPadding * 2), height);
}

- (void)bt_centerVerticallyWithLeftPadding:(CGFloat)leftPadding size:(CGSize)size
{
    [self bt_centerVerticallyWithLeftPadding:leftPadding width:size.width height:size.height];
}

-(void)bt_centerVerticallyWithLeftPadding:(CGFloat)leftPadding width:(CGFloat)width height:(CGFloat)height
{
    self.frame = CGRectMake(leftPadding,
                            self.superview.bounds.size.height/2.0 - height/2.0,
                            width, height);
}

- (void)bt_centerVerticallyWithRightPadding:(CGFloat)rightPadding size:(CGSize)size
{
    self.frame = CGRectMake(self.superview.bounds.size.width - rightPadding - size.width,
                            self.superview.bounds.size.height/2.0 - size.height/2.0,
                            size.width,
                            size.height);
}

- (void)bt_setFrameX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)bt_setFrameY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x,y, self.frame.size.width, self.frame.size.height);
}

- (void)bt_setFrameWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)bt_setFrameHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (CGSize)bt_sizeRequired
{
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX)];
}

- (CGSize)bt_sizeThatFitsWidth:(CGFloat)width
{
    return [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

- (void)bt_animateSlide:(BTViewAnimationDirection)direction animatations:(dispatch_block_t)animatations completion:(void (^)(BOOL finished))completion
{
    CGFloat initialY = self.frame.origin.y;
    CGFloat finalY = self.frame.origin.y;

    CGFloat initialHeight = self.frame.size.height;
    CGFloat finalHeight = self.frame.size.height;

    CGFloat initialAlpha = 1;
    CGFloat finalAlpha = 1;

    self.clipsToBounds = YES;

    if (direction == BTAnimateInTopToBottom) {
        initialHeight = 0;
        finalHeight = self.frame.size.height;
        initialAlpha = 0;
        finalAlpha = 1.0;
    }

    else if (direction == BTAnimateOutBottomToTop) {
        initialHeight = self.frame.size.height;
        finalHeight = 0;
        initialAlpha = 1.0;
        finalAlpha = 0;
    }

    else if (direction == BTAnimateInBottomToTop) {
        initialY = initialY + self.frame.size.height;
        initialAlpha = 0;
        finalAlpha = 1.0;
    }

    else if(direction == BTAnimateOutTopToBottom) {
        finalY = initialY + self.frame.size.height;
        initialAlpha = 1.0;
        finalAlpha = 0;
    }

    self.alpha = initialAlpha;
    [self bt_setFrameY:initialY];
    [self bt_setFrameHeight:initialHeight];

    [UIView animateWithDuration:0.25
                     animations:^{

                         [self bt_setFrameY:finalY];
                         [self bt_setFrameHeight:finalHeight];
                         self.alpha = finalAlpha;

                         if (animatations) {
                             animatations();
                         }

                     } completion:^(BOOL finished) {

                         if (completion) {
                             completion(finished);
                         }
                     }];
}

@end
