//
//  BElementCell.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 24/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BTElementCell.h"

typedef NS_ENUM(NSInteger, BElementCellHighlightStyle)
{
    BElementCellHighlightStyleNone    = 0,
    
    /* Make use of self.backgroundView */
    BElementCellHighlightStyleNormal = 1
};

@interface BElementCell : BTElementCell

@property (nonatomic, assign) BElementCellHighlightStyle highlightStyle;
@property (nonatomic, assign) NSUInteger elementId;

@end
