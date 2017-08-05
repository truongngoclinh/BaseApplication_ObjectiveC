//
//  BDividerView.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 9/2/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDividerView : UIView

typedef NS_OPTIONS(NSInteger, BDividerViewDirection)
{
    BDividerViewDirectionTop    = 0,
    BDividerViewDirectionLeft   = 1,
    BDividerViewDirectionBottom = 2,
    BDividerViewDirectionRight  = 3,
};

typedef NS_OPTIONS(NSInteger, BDividerViewOption)
{
    BDividerViewOptionTop    = 1 << BDividerViewDirectionTop,
    BDividerViewOptionRight  = 1 << BDividerViewDirectionRight,
    BDividerViewOptionBottom = 1 << BDividerViewDirectionBottom,
    BDividerViewOptionLeft   = 1 << BDividerViewDirectionLeft,
};

@property (nonatomic, assign) BDividerViewOption option;
@property (nonatomic, assign) CGFloat thickness;
@property (nonatomic, strong) UIColor *color;

/** @param insetVertical: vertical inset, only applicable to vertical dividers.
 *  @param insetHorizontal: hotizontal inset, only applicable to horizontal dividers.
 */
- (instancetype)initWithFrame:(CGRect)frame
                insetVertical:(CGFloat)insetVertical
              insetHorizontal:(CGFloat)insetHorizontal;

@end
