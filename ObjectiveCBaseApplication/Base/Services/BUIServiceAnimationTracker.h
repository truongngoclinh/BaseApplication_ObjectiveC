//
//  BUIServiceAnimationTracker.h
//  Cyberpay
//
//  Created by Linh on 25/2/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BUIServiceAnimationTrackerBlock)(void);

@interface BUIServiceAnimationTracker : NSObject

- (void)animatingObject:(NSObject *)object;
- (void)animatedObject:(NSObject *)object;
- (void)executeBlockAfterAnimation:(BUIServiceAnimationTrackerBlock)block;

@end
