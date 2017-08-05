//
//  BTCustomElement.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 18/4/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTElement.h"

@interface BTCustomElement : BTElement

@property (nonatomic, strong, readonly) UIView *view;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

- (id)initWithView:(UIView *)view;

@end
