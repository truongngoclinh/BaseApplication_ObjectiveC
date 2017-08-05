//
//  BTSwitchElement.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTLabelElement.h"

@interface BTSwitchElement : BTLabelElement

- (id)initWithTitle:(NSString *)title image:(UIImage *)image switchOn:(BOOL)isOn;

@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL hideSwitch;

@end
