//
//  BUIServiceAnimationTracker.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 25/2/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "BUIServiceAnimationTracker.h"

BLogLevel(BLogLevelInfo)

@interface BUIServiceAnimationTracker ()

@property (nonatomic, strong) NSMutableArray *animatingObjects;
@property (nonatomic, strong) NSMutableArray *blocks;

@end

@implementation BUIServiceAnimationTracker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animatingObjects = [NSMutableArray array];
        _blocks = [NSMutableArray array];
    }
    return self;
}

- (void)animatingObject:(NSObject *)object
{
    DDLogVerbose(@"%@: %@", NSStringFromSelector(_cmd), object);
    [self.animatingObjects addObject:object];
}

- (void)animatedObject:(NSObject *)object
{
    DDLogVerbose(@"%@: %@", NSStringFromSelector(_cmd), object);
    [self.animatingObjects removeObject:object];
    
    if (self.animatingObjects.count == 0) {
        [self processPendingBlocks];
    }
}

- (void)processPendingBlocks
{
    if (!self.blocks.count) {
        return;
    }
    
    DDLogInfo(@"[%@] Processing pending blocks", self.class);
    
    BUIServiceAnimationTrackerBlock block = [self.blocks firstObject];
    [self.blocks removeObjectAtIndex:0];
    
    block();
}

- (void)executeBlockAfterAnimation:(BUIServiceAnimationTrackerBlock)block
{
    NSParameterAssert(block);
    if (self.animatingObjects.count == 0) {
        block();
    } else {
        [self.blocks addObject:block];
        DDLogInfo(@"[%@] Delayed execution of block as objects are animating: %@", self, self.animatingObjects);
    }
}

@end
