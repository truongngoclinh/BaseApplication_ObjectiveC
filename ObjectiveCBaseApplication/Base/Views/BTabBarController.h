//
//  BTabBarController.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 29/1/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTraverseProtocol.h"

extern NSString *const BTabBarControllerSelectedNotification;

@interface BTabBarController : UITabBarController <BTraverseProtocol>

@end
