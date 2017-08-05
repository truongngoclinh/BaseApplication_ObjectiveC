//
//  BBarButtonItem.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 18/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BBarButtonItem.h"
#import "BBarButton.h"

@interface BBarButtonItem ()

@property (nonatomic, strong) BBarButton *barButton;

@end

@implementation BBarButtonItem

+ (BBarButtonItem *)barButtonItemTitle:(NSString *)title selector:(SEL)selector target:(id)target
{
    return [BBarButtonItem barButtonItemImage:nil highlightedImage:nil title:title selector:selector target:target];
}

+ (BBarButtonItem *)barButtonItemImage:(UIImage *)image selector:(SEL)selector target:(id)target
{
    return [BBarButtonItem barButtonItemImage:image highlightedImage:nil title:nil selector:selector target:target];
}

+ (BBarButtonItem *)barButtonItemImage:(UIImage *)image selector:(SEL)selector target:(id)target imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
    return [BBarButtonItem barButtonItemImage:image highlightedImage:nil title:nil selector:selector target:target imageEdgeInsets:imageEdgeInsets];
}

+ (BBarButtonItem *)barButtonItemImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage selector:(SEL)selector target:(id)target
{
    return [BBarButtonItem barButtonItemImage:image highlightedImage:highlightedImage title:nil selector:selector target:target];
}

+ (BBarButtonItem *)backBarButtonItemTitle:(NSString *)title selector:(SEL)selector target:(id)target
{
    return [BBarButtonItem barButtonItemImage:[UIImage imageNamed:@"element_titlebar_icon_arrow_left2"]
                              highlightedImage:nil
                                         title:title
                                      selector:selector
                                        target:target];
}

+ (BBarButtonItem *)barButtonItemImage:(UIImage *)image
                       highlightedImage:(UIImage *)highlightedImage
                                  title:(NSString *)title
                               selector:(SEL)selector
                                 target:(id)target
{
    return [BBarButtonItem barButtonItemImage:image highlightedImage:highlightedImage title:title selector:selector target:target imageEdgeInsets:UIEdgeInsetsZero];
}

+ (BBarButtonItem *)barButtonItemImage:(UIImage *)image
                       highlightedImage:(UIImage *)highlightedImage
                                  title:(NSString *)title
                               selector:(SEL)selector
                                 target:(id)target
                            imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
    BBarButton *button = [[BBarButton alloc] initWithFrame:CGRectZero];
    button.titleLabel.font = [BTheme lightFontOfSize:16];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    
    UIColor *textColor = [UIColor whiteColor];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:[textColor colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
    [button setTitleColor:[textColor colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
    
    button.imageView.contentMode = UIViewContentModeCenter;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];

    CGSize size = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (image) {
        button.imageEdgeInsets = imageEdgeInsets;
    }

    BBarButtonItem *barButtonItem = [[BBarButtonItem alloc] initWithCustomView:button];
    barButtonItem.barButton = button;
    
    if (title.length) barButtonItem.spacing = 10;
    
    return barButtonItem;
}

- (void)updateImage:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage
{
    [self.barButton setImage:image forState:UIControlStateNormal];
    [self.barButton setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setImageInsets:(UIEdgeInsets)imageInsets
{
    [super setImageInsets:imageInsets];
    self.barButton.imageEdgeInsets = imageInsets;
}

@end
