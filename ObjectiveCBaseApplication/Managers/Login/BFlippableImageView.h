//
//  BFlippableImageView.h
//  Cyberpay
//
//  Created by Linh on 27/10/15.
//  Copyright © 2015 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFlippableImageView : UIView

- (instancetype)initWithFrame:(CGRect)frame
         imageBackgroundColor:(UIColor*)imageBackgroundColor
                 cornerRadius:(CGFloat)cornerRadius;

- (void)setImage:(UIImage *)image animated:(BOOL)animated;

@end
