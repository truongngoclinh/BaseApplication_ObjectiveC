//
//  CPHorizontalButtonItem.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BHorizontalButtonItem : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, nullable, readonly) NSString *subtitle;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, assign, readonly) SEL selector;

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString * _Nullable)subtitle
                        image:(UIImage *)image
                     selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
