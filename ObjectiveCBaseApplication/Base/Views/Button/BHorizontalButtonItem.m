//
//  CPHorizontalButtonItem.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BHorizontalButtonItem.h"

@implementation BHorizontalButtonItem

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString * _Nullable)subtitle
                        image:(UIImage *)image
                     selector:(SEL)selector
{
    self = [super init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _image = image;
        _selector = selector;
    }
    return self;
}

@end
