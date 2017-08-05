//
//  BTraverseItem.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 7/10/15.
//  Copyright © 2015 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTraversePath.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTraverseItem : NSObject

@property (nonatomic, strong, readonly) NSArray<NSString *> *pathComponents;
@property (nonatomic, strong, readonly, nullable) id object;

- (instancetype)initWithPathComponents:(NSArray<NSString *> *)pathComponents
                                object:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
