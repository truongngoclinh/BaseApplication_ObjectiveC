//
//  NSDate+BFormatter.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "NSDate+BFormatter.h"

#import "BDateFormatter.h"

@implementation NSDate (BFormatter)

- (NSString *)b_formattedDisplayDate
{
    static BDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[BDateFormatter alloc] init];
        formatter.dateFormat = @"dd/MM/yyyy";
    });
    return [formatter stringFromDate:self];
}

- (NSString *)b_formattedDisplayDateTime
{
    static BDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[BDateFormatter alloc] init];
        formatter.dateFormat = @"dd/MM/yyyy HH:mm";
    });
    return [formatter stringFromDate:self];
}

- (NSString *)b_formattedStringWithDateFormat:(NSString *)dateFormat;
{
    BDateFormatter *formatter = [[BDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:self];
}

@end
