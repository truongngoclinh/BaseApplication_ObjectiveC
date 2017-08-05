//
//  BTPageViewSample.h
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTPageView.h"

@interface BTPageViewSample : BTPageView

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign, readonly) NSInteger reusedCount;
@property (nonatomic, assign, readonly) NSInteger recycledCount;

@end
