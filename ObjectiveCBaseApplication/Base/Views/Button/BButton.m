//
//  BButton.m
//  Cyberpay
//
//  Created by Andrew Eng on 30/1/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "BButton.h"

@interface BButton ()

@property (nonatomic, assign) BButtonLayout layout;

/**
 Hack: in iOS7 [UIButton titleLabel] will result in call loop:
 -intrinsicContentSize -sizeOccupiedByTitleAndImage -titleLabel -intrinsicContentSize
 Store a seperate copy of the label to request its size bypassing [UIButton titleLabel]
 */
@property (nonatomic, strong) UILabel *aTitleLabel;

@end

@implementation BButton

- (CGSize)intrinsicContentSize
{
    CGSize contentSize = [self sizeOccupiedByTitleAndImage];
    CGSize backgroundImageSize = [self backgroundImageSize];
    
    return CGSizeMake(MAX(contentSize.width, backgroundImageSize.width),
                      MAX(contentSize.height, backgroundImageSize.height));
}

#pragma mark - Init

- (instancetype)initWithLayout:(BButtonLayout)layout
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _layout = layout;
        _shouldScaleImage = YES;
    }
    return self;
}

#pragma mark - Others

- (void)setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment
{
    [super setContentHorizontalAlignment:contentHorizontalAlignment];
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGSize titleSize = [self.titleLabel intrinsicContentSize];
    CGSize titleSizeWithInset = CGSizeMake(titleSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                                           titleSize.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
    CGSize imageSize = [self imageSize];
    CGSize imageSizeWithInset = CGSizeMake(imageSize.width + self.imageEdgeInsets.left + self.imageEdgeInsets.right,
                                           imageSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom);

    CGSize contentSize = [self sizeOccupiedByTitleAndImage];
    
    // Calculate start x
    CGFloat x = floor((width - contentSize.width)/2);
    switch (self.contentHorizontalAlignment) {
        
        case UIControlContentHorizontalAlignmentCenter:
            break;
            
        case UIControlContentHorizontalAlignmentLeft:
            x = 0;
            break;
            
        case UIControlContentHorizontalAlignmentRight:
            x = width - contentSize.width;
            break;
            
        case UIControlContentHorizontalAlignmentFill:
        default:
            NSParameterAssert(NO);
            break;
    }
    
    CGFloat y = floor((height - contentSize.height)/2);
    
    switch (self.layout) {
        case BButtonLayoutImageLeft: {
            // Image
            x += self.imageEdgeInsets.left;
            CGFloat imageY = (height - imageSizeWithInset.height)/2 + self.imageEdgeInsets.top;
            self.imageView.frame = CGRectMake(x, imageY, imageSize.width, imageSize.height);
            x = CGRectGetMaxX(self.imageView.frame) + self.imageEdgeInsets.right;
            
            // Title
            x += self.titleEdgeInsets.left;
            CGFloat titleY = (height - titleSizeWithInset.height)/2 + self.titleEdgeInsets.top;
            self.titleLabel.frame = CGRectMake(x, titleY, titleSize.width, titleSize.height);
            break;
        }
        case BButtonLayoutImageRight: {
            // Title
            x += self.titleEdgeInsets.left;
            CGFloat titleY = (height - titleSizeWithInset.height)/2 + self.titleEdgeInsets.top;
            self.titleLabel.frame = CGRectMake(x, titleY, titleSize.width, titleSize.height);
            x = CGRectGetMaxX(self.titleLabel.frame) + self.titleEdgeInsets.right;

            // Image
            x += self.imageEdgeInsets.left;
            CGFloat imageY = (height - imageSizeWithInset.height)/2 + self.imageEdgeInsets.top;
            self.imageView.frame = CGRectMake(x, imageY, imageSize.width, imageSize.height);
            break;
        }
        case BButtonLayoutImageTop: {
            // Image
            y += self.imageEdgeInsets.top;
            CGFloat imageX = (width - imageSizeWithInset.width)/2 + self.imageEdgeInsets.left;
            self.imageView.frame = CGRectMake(imageX, y, imageSize.width, imageSize.height);
            y = CGRectGetMaxY(self.imageView.frame) + self.imageEdgeInsets.bottom;
            
            // Title
            y += self.titleEdgeInsets.top;
            CGFloat titleX = (width - titleSizeWithInset.width)/2 + self.titleEdgeInsets.left;
            self.titleLabel.frame = CGRectMake(titleX, y, titleSize.width, titleSize.height);
            break;
        }
        case BButtonLayoutImageBottom: {
            // Title
            y += self.titleEdgeInsets.top;
            CGFloat titleX = (width - titleSizeWithInset.width)/2 + self.titleEdgeInsets.left;
            self.titleLabel.frame = CGRectMake(titleX, y, titleSize.width, titleSize.height);
            y = CGRectGetMaxY(self.titleLabel.frame) + self.titleEdgeInsets.bottom;
            
            //Image
            y += self.imageEdgeInsets.top;
            CGFloat imageX = (width - imageSizeWithInset.width)/2 + self.imageEdgeInsets.left;
            self.imageView.frame = CGRectMake(imageX, y, imageSize.width, imageSize.height);
            break;
        }
        default:
            NSParameterAssert(NO);
            break;
    }
}

- (CGSize)sizeOccupiedByTitleAndImage
{
    CGSize titleSize = [self titleLabelSize];
    CGSize imageSize = [self imageSize];
    
    CGSize titleSizeWithInset = CGSizeMake(titleSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                                           titleSize.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    CGSize imageSizeWithInset = CGSizeMake(imageSize.width + self.imageEdgeInsets.left + self.imageEdgeInsets.right,
                                           imageSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom);
    
    CGSize contentSize = CGSizeZero;
    switch (self.layout) {
        case BButtonLayoutImageLeft:
        case BButtonLayoutImageRight:
            contentSize.width = imageSizeWithInset.width + titleSizeWithInset.width;
            contentSize.height = MAX(imageSizeWithInset.height, titleSizeWithInset.height);
            break;
        case BButtonLayoutImageTop:
        case BButtonLayoutImageBottom:
            contentSize.width = MAX(imageSizeWithInset.width, titleSizeWithInset.width);
            contentSize.height = imageSizeWithInset.height + titleSizeWithInset.height;
            break;
        default:
            NSParameterAssert(NO);
            break;
    }
    return contentSize;
}

#pragma mark - Size

- (CGSize)titleLabelSize
{
    if (!self.aTitleLabel) {
        self.aTitleLabel = self.titleLabel;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"8")) {
        self.aTitleLabel.text = [self titleForState:self.state];
    }
    
    return self.aTitleLabel.intrinsicContentSize;
}

- (CGSize)imageSize
{
    if (self.shouldScaleImage) {
        return BXSize([self imageForState:UIControlStateNormal].size);
    } else {
        return [self imageForState:UIControlStateNormal].size;
    }
}

- (CGSize)backgroundImageSize
{
    if (self.shouldScaleImage) {
        return BXSize([self backgroundImageForState:UIControlStateNormal].size);
    } else {
        return [self backgroundImageForState:UIControlStateNormal].size;
    }
}

@end
