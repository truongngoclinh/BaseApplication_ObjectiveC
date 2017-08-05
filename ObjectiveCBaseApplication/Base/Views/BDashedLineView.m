//
//  BDashedLineView.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 30/7/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BDashedLineView.h"

@interface BDashedLineView ()

@end

@implementation BDashedLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _dashColor = [UIColor blackColor];
        _direction = BDashedLineDirectionVertical;
        _dashWidth = BX(3);
        _spaceWith = BX(2);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [self.dashColor CGColor]);
    
    CGFloat lengths[] = {self.dashWidth, self.spaceWith};
    CGContextSetLineDash(context, 0.0, lengths, 2);
    CGContextSetLineWidth(context, 0.6);
    
    switch (_direction) {
        case BDashedLineDirectionVertical: {
            CGFloat thickness = CGRectGetHeight(rect);
            CGContextMoveToPoint(context, 0, thickness/2);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), thickness/2);
            break;
        }
        case BDashedLineDirectionHorizontal: {
            CGFloat thickness = CGRectGetWidth(rect);
            CGContextMoveToPoint(context, thickness/2, 0);
            CGContextAddLineToPoint(context, thickness/2, CGRectGetHeight(rect));
            break;
        }
    }
    
    CGContextStrokePath(context);
}

@end
