//
//  NSURL+BTFoundation.h
//  BTFoundation
//
//  Created by Lee Sing Jie on 23/10/14.
//  Copyright (c) 2014 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (BTFoundation)

+ (NSURL *)bt_URLWithNonEscapedString:(NSString *)URLString;

@end
