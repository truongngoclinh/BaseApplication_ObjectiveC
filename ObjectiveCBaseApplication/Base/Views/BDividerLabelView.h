//
//  BDividerLabel.h
//  ObjectiveCBaseApplication
//
//  Created by LABS-LEES-MAC on 24/7/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BDividerLabelViewStyle) {
    BDividerLabelViewStyleViewDivider = 0,
    BDividerLabelViewStyleTableViewSectionGap = 1,
};

@interface BDividerLabelView : UIView

- (instancetype)initWithFrame:(CGRect)frame style:(BDividerLabelViewStyle)style;

@property (nonatomic, strong) NSString *title;

@end
