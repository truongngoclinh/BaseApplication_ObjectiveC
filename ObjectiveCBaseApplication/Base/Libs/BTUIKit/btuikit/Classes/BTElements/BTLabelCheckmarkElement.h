//
//  BTLabelCheckmarkElement.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 10/5/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTLabelElement.h"

@interface BTLabelCheckmarkElement : BTLabelElement

- (id)initWithTitle:(NSString *)title checked:(BOOL)isChecked;

@property (nonatomic, assign) BOOL isChecked;

@end
