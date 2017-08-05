//
//  BUIManager.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 23/2/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "BManager.h"
#import "BUIService.h"

typedef NS_ENUM(NSInteger, BUIManagerRootVCOption)
{
    BUIManagerRootVCOptionDefaultTabMe = 1,
};

@class BTraverseItem;
@interface BUIManager : BManager

- (instancetype)initWithUIService:(BUIService *)UIService;

- (void)showLoginRootViewController;
- (void)showRootViewController;

- (void)reloadRootViewControllerWithOption:(BUIManagerRootVCOption)option;

- (void)traverse:(BTraverseItem *)traverseItem;

@end
