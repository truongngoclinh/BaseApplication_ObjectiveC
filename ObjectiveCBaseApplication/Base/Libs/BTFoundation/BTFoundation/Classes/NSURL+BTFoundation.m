//
//  NSURL+BTFoundation.m
//  BTFoundation
//
//  Created by Lee Sing Jie on 23/10/14.
//  Copyright (c) 2014 Garena. All rights reserved.
//

#import "NSURL+BTFoundation.h"

@implementation NSURL (BTFoundation)

+ (NSURL *)bt_URLWithNonEscapedString:(NSString *)URLString
{
    NSURL *url = [NSURL URLWithString:URLString];

    if (url == nil) {
        url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    return url;
}

@end
