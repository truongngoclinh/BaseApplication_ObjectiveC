//
//  UIScrollView+BFitSize.h
//  Cyberpay
//
//  Created by yangzhixing on 1/9/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (BFitSize)

/*
 * @short Make the contentView have the same width of scrollView. The height will be zero.
 */
- (void)b_fitScrollViewWidth;

/*
 * @short Make the contentView have at least the same height of scrollView. The width will be zero.
 */
- (void)b_fitScrollViewMinimumHeight;

/*
 * @short Make the contentView have the same width and at least the same height of scrollView.
 * The actual height could be more.
 */
- (void)b_fitScrollViewWidthAndMininumHeight;

@end

NS_ASSUME_NONNULL_END
