//
//  BDashedLineView.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 30/7/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BDashedLineDirection){
    BDashedLineDirectionVertical = 1,
    BDashedLineDirectionHorizontal = 2
};

@interface BDashedLineView : UIView

@property (nonatomic, strong) UIColor *dashColor;
@property (nonatomic, assign) CGFloat dashWidth;
@property (nonatomic, assign) CGFloat spaceWith;
@property (nonatomic) BDashedLineDirection direction;

@end
