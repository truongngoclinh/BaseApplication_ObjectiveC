//
//  BLoginNavigationAnimationProtocol.h
//  Cyberpay
//
//  Created by Linh on 4/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

typedef NS_ENUM(NSInteger, kLoginNavigationAnimationType) {
    kLoginNavigationAnimationTypePushed = 0,
    kLoginNavigationAnimationTypePoped,
    kLoginNavigationAnimationTypeNewVCOnTop,
    kLoginNavigationAnimationTypeNewVCRemoved,
};

#import <Foundation/Foundation.h>

@protocol BLoginNavigationAnimationProtocol <NSObject>

- (void)prepareAnimationForTransitionType:(kLoginNavigationAnimationType)type;

- (void)performAnimationForTransitionType:(kLoginNavigationAnimationType)type;

- (void)didFinishAnimationForTransitionType:(kLoginNavigationAnimationType)type;

@end
