//
//  BTPageHostSample.m
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTPageHostSample.h"

#import "BTPageViewSample.h"

@implementation BTPageHostSample

+ (Class)viewClass
{
    return [BTPageViewSample class];
}

- (BTPageView *)viewForScrollableView:(BTPagedScrollView *)view
{
    BTPageViewSample *sample = (BTPageViewSample *)[super viewForScrollableView:view];

    sample.text = self.title;

    return sample;
}

@end
