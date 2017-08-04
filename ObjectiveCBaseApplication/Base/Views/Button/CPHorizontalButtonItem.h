//
//  CPHorizontalButtonItem.h
//  Cyberpay
//
//  Created by yangzhixing on 7/9/16.
//  Copyright © 2016 Garena. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPHorizontalButtonItem : NSObject

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
