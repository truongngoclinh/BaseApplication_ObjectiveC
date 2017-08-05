//
//  BNavigationInteractiveProtocol.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 14/9/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, BNavigationInteractivePopOption)
{
    BNavigationInteractivePopOptionEnableEvenWhenNavigationBarHidden = 1 << 0,
    BNavigationInteractivePopOptionEnableEvenWhenLeftButtonDisabled  = 1 << 1,
};

@protocol BNavigationInteractivePopProtocol <NSObject>

- (BOOL)supportsInteractivePop;

@optional

- (BNavigationInteractivePopOption)interactivePopOption;

@end