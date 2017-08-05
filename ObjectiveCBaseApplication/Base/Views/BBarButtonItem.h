//
//  BBarButtonItem.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 18/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBarButtonItem : UIBarButtonItem

@property (nonatomic, assign) CGFloat spacing;

+ (BBarButtonItem *)barButtonItemTitle:(NSString *)title selector:(SEL)selector target:(id)target;

+ (BBarButtonItem *)barButtonItemImage:(UIImage *)image selector:(SEL)selector target:(id)target;

+ (BBarButtonItem *)barButtonItemImage:(UIImage *)image selector:(SEL)selector target:(id)target imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;

+ (BBarButtonItem *)barButtonItemImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage selector:(SEL)selector target:(id)target;

+ (BBarButtonItem *)backBarButtonItemTitle:(NSString *)title selector:(SEL)selector target:(id)target;

- (void)updateImage:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;

@end

NS_ASSUME_NONNULL_END
