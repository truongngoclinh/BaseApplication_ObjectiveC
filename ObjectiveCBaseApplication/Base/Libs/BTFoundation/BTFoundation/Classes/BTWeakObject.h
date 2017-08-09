//
//  BTWeakObject.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 7/8/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTWeakObject : NSObject

- (id)initWithObject:(id)object;

- (id)object;

- (BOOL)isNil;

@end
