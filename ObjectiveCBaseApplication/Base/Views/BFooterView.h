//
//  BFooterView.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 23/7/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFooterView : UIView

@property (nonatomic, assign, readonly) UIEdgeInsets contentInset;
@property (nonatomic, strong, readonly) UIView *contentView;

/** Defaults to False */
@property (nonatomic, assign) BOOL showDivider;

/** @param shouldScale: defaults to YES */
- (instancetype)initWithFrame:(CGRect)frame shouldScale:(BOOL)shouldScale;

@end
