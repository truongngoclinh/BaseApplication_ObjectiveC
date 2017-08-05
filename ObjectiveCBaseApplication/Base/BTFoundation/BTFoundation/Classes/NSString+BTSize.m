//
//  NSString+Size.m
//  BeeShop
//
//  Created by ZhangLianzhou on 1/7/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "NSString+BTSize.h"

@implementation NSString(BTSize)

- (CGSize)bt_rectSizeWithFont:(UIFont *)font
{
    return [self bt_rectSizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

-(CGSize)bt_rectSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)constrainedSize
{
    return [self bt_rectSizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
}

-(CGSize)bt_rectSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size;
    //IOS 7
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;

        size = [self boundingRectWithSize:constrainedSize
                                  options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName: font,
                                            NSParagraphStyleAttributeName: paragraphStyle}
                                  context:nil].size;

        size = CGSizeMake(MIN(ceil(size.width), constrainedSize.width),
                          MIN(ceil(size.height), constrainedSize.height));
    } else {
        //IOS 6
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font constrainedToSize:constrainedSize
                    lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    
    return size;
}

@end
