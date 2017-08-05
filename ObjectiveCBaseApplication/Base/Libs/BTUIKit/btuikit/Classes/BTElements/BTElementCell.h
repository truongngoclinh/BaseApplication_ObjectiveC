//
//  BTElementCell.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTElementCell : UITableViewCell



/*
Class Methods to theme default instances of BTElementCell 
**/
+ (void)themeDefaultTitleColor:(UIColor *)color;
+ (void)themeDefaultSubTitleColor:(UIColor *)subTitlecolor;
+ (void)themeDefaultTitleFont:(UIFont *)titleFont;
+ (void)themeDefaultSubTitleFont:(UIFont *)subTitleFont;
+ (void)themeDefaultBackgroundColor:(UIColor *)backgroundColor;
+ (void)themeDefaultSelectedBackgroundColor:(UIColor *)selectedBackgroundColor;
+ (void)themeDefaultBorderColor:(UIColor *)borderColor;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *subTitleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *subTitleFont;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderThickness;
@property (nonatomic, assign) BOOL showTopBorder;
@property (nonatomic, assign) BOOL showBottomBorder;
@property (nonatomic, assign) CGFloat bottomBorderLeftPadding;
@property (nonatomic, assign) CGFloat bottomBorderRightPadding;

@end
