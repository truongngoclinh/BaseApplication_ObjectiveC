//
//  BTKeyboardNotifier.m
//  BTFoundation
//
//  Created by Lee Sing Jie on 24/10/14.
//  Copyright (c) 2014 Garena. All rights reserved.
//

#import "BTKeyboardNotifier.h"

@interface BTKeyboardNotifierWeakObject : NSObject

@property (nonatomic, weak, readonly) id object;

- (id)initWithObject:(id)object;
- (BOOL)isNil;

@end

#pragma mark - BTKeyboardNotifier

@interface BTKeyboardNotifier()

@property (nonatomic, strong) NSMutableArray *delegates;

@end

@implementation BTKeyboardNotifier

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.delegates = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)addDelegate:(id <BTKeyboardNotifier>)delegate
{
    [self trim];
    
    [self.delegates addObject:[[BTKeyboardNotifierWeakObject alloc] initWithObject:delegate]];
}

- (void)trim
{
    NSMutableArray *emptyDelegates = [NSMutableArray array];
    
    [self.delegates enumerateObjectsUsingBlock:^(BTKeyboardNotifierWeakObject *value, NSUInteger idx, BOOL *stop) {
        id delegate = value.object;
        if (delegate == nil) {
            [emptyDelegates addObject:value];
        }
    }];
    
    [self.delegates removeObjectsInArray:emptyDelegates];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *animation = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveInfo = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect bounds = [value CGRectValue];
    CGFloat animationDuration = [animation floatValue];
    UIViewAnimationOptions animationOption = [curveInfo intValue] << 16;
    
    [self.delegates enumerateObjectsUsingBlock:^(BTKeyboardNotifierWeakObject *value, NSUInteger idx, BOOL *stop) {
        id delegate = value.object;
        
        if (delegate) {
            [delegate keyboardWillShowWithRect:bounds duration:animationDuration animationOptions:animationOption];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *animation = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveInfo = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect bounds = [value CGRectValue];
    CGFloat animationDuration = [animation floatValue];
    UIViewAnimationOptions animationOption = [curveInfo intValue] << 16;
    
    [self.delegates enumerateObjectsUsingBlock:^(BTKeyboardNotifierWeakObject *value, NSUInteger idx, BOOL *stop) {
        id delegate = value.object;
        
        if (delegate) {
            [delegate keyboardWillHideWithRect:bounds duration:animationDuration animationOptions:animationOption];
        }
    }];
}

@end

#pragma mark - BTKeyboardNotifierWeakObject

@implementation BTKeyboardNotifierWeakObject

@synthesize object = _object;

- (id)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

- (BOOL)isNil
{
    return self.object == nil;
}

- (NSString *)description
{
    NSString *description = [super description];
    return [NSString stringWithFormat:@"%@:%@", description, self.object];
}

@end
