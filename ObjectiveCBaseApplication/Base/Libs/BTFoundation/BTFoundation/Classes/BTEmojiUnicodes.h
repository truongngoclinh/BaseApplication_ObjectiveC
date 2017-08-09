//
//  BTEmojiUnicodes.h
//  BTFoundation
//
//  Created by Ziwei Peng on 19/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTEmojiUnicodes : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)unicodes;

@end
