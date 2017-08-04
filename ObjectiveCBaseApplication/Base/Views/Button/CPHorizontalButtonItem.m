//
//  CPHorizontalButtonItem.m
//  Cyberpay
//
//  Created by yangzhixing on 7/9/16.
//  Copyright © 2016 Garena. All rights reserved.
//

#import "CPHorizontalButtonItem.h"

@implementation CPHorizontalButtonItem

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
