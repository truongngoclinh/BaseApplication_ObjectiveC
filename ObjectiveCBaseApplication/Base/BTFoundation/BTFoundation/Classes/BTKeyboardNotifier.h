//
//  BTKeyboardNotifier.h
//  BTFoundation
//
//  Created by Lee Sing Jie on 24/10/14.
//  Copyright (c) 2014 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BTKeyboardNotifier <NSObject>

- (void)keyboardWillShowWithRect:(CGRect)rect
                        duration:(CGFloat)duration
                animationOptions:(UIViewAnimationOptions)animationOptions;

- (void)keyboardWillHideWithRect:(CGRect)rect
                        duration:(CGFloat)duration
                animationOptions:(UIViewAnimationOptions)animationOptions;

@end

@interface BTKeyboardNotifier : NSObject

+ (instancetype)sharedInstance;
- (void)addDelegate:(id <BTKeyboardNotifier>)delegate;

@end
