//
//  BTraverseProtocol.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 7/10/15.
//  Copyright © 2015 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTraverseItem.h"

@protocol BTraverseProtocol <NSObject>

NS_ASSUME_NONNULL_BEGIN

- (BOOL)canTraverse:(BTraverseItem *)traverseItem;
- (void)traverse:(BTraverseItem *)traverseItem;

NS_ASSUME_NONNULL_END

@end
