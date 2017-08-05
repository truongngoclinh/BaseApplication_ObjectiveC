//
//  BTLabelElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTLabelElement.h"

#import "BTElementCell.h"

static UIColor *placeHolderColor;
static UIFont *placeHolderFont;

@implementation BTLabelElement

- (id)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title subTitle:nil];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image
{
    return [self initWithTitle:title subTitle:nil image:image];
}

- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    return [self initWithTitle:title subTitle:subTitle image:nil];
}

- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image
{
    self = [super init];

    if (self) {
        self.title = title;
        self.subTitle = subTitle;
        self.icon = image;

        self.accessibilityLabel = title;
    }

    return self;
}

+ (void)themeDefaultPlaceHolderColor:(UIColor *)color
{
    placeHolderColor = color;
}

+ (void)themeDefaultPlaceHolderFont:(UIFont *)font
{
    placeHolderFont = font;
}

- (UIColor *)defaultCellPlaceHolderColor
{
    if (placeHolderColor) {
        return placeHolderColor;
    }

    return self.titleColor;
}

- (UIFont *)defaultCellPlaceHolderFont
{
    if (placeHolderFont) {
        return placeHolderFont;
    }

    return [UIFont systemFontOfSize:16];
}

- (BTElementCell *)cellForTableView:(UITableView *)tableView
{
    BTElementCell *cell = (BTElementCell *)[super cellForTableView:tableView];
    
    cell.textLabel.text = self.title;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;

    cell.detailTextLabel.text = self.subTitle;
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;

    cell.imageView.image = self.icon;

    cell.titleColor = self.titleColor;
    cell.subTitleColor = self.subTitleColor;
    cell.titleFont = self.titleFont;
    cell.subTitleFont = self.subTitleFont;

    //PlaceholderSupport
    if (self.title.length == 0 && self.placeholder.length > 0) {
        cell.textLabel.text = self.placeholder;
        if (self.placeholderColor) {
            cell.titleColor = self.placeholderColor;
        } else {
            cell.titleColor = [self defaultCellPlaceHolderColor];
        }
        if (self.placeholderFont) {
            cell.titleFont = self.placeholderFont;
        } else {
            cell.titleFont = [self defaultCellPlaceHolderFont];
        }
    }

    if (self.accessoryView) {
        cell.accessoryView = self.accessoryView;
    }

    return cell;
}

@end
