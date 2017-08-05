//
//  BElement.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 24/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BTElement.h"
#import "BElementCell.h"

@interface BElement : BTElement

NS_ASSUME_NONNULL_BEGIN

/** Cell associated with this element. nil if cell has not been created or has been reused */
@property (nonatomic, weak, readonly, nullable) BElementCell *cell;

@end

NS_ASSUME_NONNULL_END
