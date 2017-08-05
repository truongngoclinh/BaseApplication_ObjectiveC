//
//  BTLabelElement.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTElement.h"
#import "BTElementCell.h"

@interface BTLabelElement : BTElement

/*
 Class Methods to theme default instances of BTElementCell
 **/
+ (void)themeDefaultPlaceHolderColor:(UIColor *)color;
+ (void)themeDefaultPlaceHolderFont:(UIFont *)font;

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title image:(UIImage *)image;
- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIImage *icon;

//Placeholder properties are used if they are set and title is empty
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *subTitleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *subTitleFont;

@property (nonatomic, strong) UIView *accessoryView;

@end
