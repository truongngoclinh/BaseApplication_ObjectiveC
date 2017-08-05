//
//  BTextView.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 17/4/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

/** Should automatically hide placeholder when content is empty and the textView is first responder. Defaults to YES.*/
@property (nonatomic, assign) BOOL hidesPlaceholderWithEmptyTextWhenFirstResponder;

- (instancetype)initWithFrame:(CGRect)frame;

@end
