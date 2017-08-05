//
//  BNavigationController.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 29/1/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNavigationInteractiveProtocol.h"
#import "BTraverseProtocol.h"

@class BNavigationController;
@protocol BNavigationControllerEvents <NSObject>

@optional;
- (void)navigationController:(BNavigationController *)navigationController willShowViewControllerAnimated:(BOOL)animated;

@end

@interface BNavigationController : UINavigationController <BTraverseProtocol>

@end
