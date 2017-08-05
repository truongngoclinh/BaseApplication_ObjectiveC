//
//  BTraversePath.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 4/4/16.
//  Copyright © 2016 Garena. All rights reserved.
//

#ifndef BTraversePath_h
#define BTraversePath_h

/** 
 * Traverse to notification page
 */
extern NSString *const BTraversePathAppNotification;

/** 
 * Traverse is triggered by quick scan.
 * Usage: "<BTraversePathQuickScan>/<identifier>"
 */
extern NSString *const BTraversePathQuickScan;

/** 
 * Traverse is triggered by tapping on a notification.
 * Usage: "<BTraversePathNotification>/<identifier>"
 */
extern NSString *const BTraversePathNotification;

/**
 * Traverse to sell products page.
 */
extern NSString *const BTraversePathAllProducts;

#endif /* BTraversePath_h */
