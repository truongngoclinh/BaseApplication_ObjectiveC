//
//  BDividerView.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 9/2/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BDividerView.h"

@interface BDividerView ()

@property (nonatomic, strong) NSArray *dividerViews;

@property (nonatomic, assign) CGFloat insetVertical;
@property (nonatomic, assign) CGFloat insetHorizontal;

@end

@implementation BDividerView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame insetVertical:0 insetHorizontal:0];
}

- (instancetype)initWithFrame:(CGRect)frame
                insetVertical:(CGFloat)insetVertical
              insetHorizontal:(CGFloat)insetHorizontal
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _color = [BTheme dividerColor];
        _thickness = BX(0.5);
        
        _insetVertical = insetVertical;
        _insetHorizontal = insetHorizontal;
        
        NSMutableArray *dividerViews = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIView *dividerView = [[UIView alloc] initWithFrame:CGRectZero];
            dividerView.backgroundColor = _color;
            dividerView.hidden = YES;
            
            [dividerViews addObject:dividerView];
            [self addSubview:dividerView];
        }
        _dividerViews = [dividerViews copy];
        
        [self configureConstraints];
    }
    return self;
}

- (void)configureConstraints
{
    [self.dividerViews enumerateObjectsUsingBlock:^(UIView *dividerView, NSUInteger idx, BOOL *stop) {
        
        [dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (idx == BDividerViewDirectionTop) {
                make.top.equalTo(self.mas_top);
                make.leading.equalTo(self.mas_leading).offset(self.insetHorizontal);
                make.trailing.equalTo(self.mas_trailing).offset(-self.insetHorizontal);
            }
            else if (idx == BDividerViewDirectionRight) {
                make.top.equalTo(self.mas_top).offset(self.insetVertical);
                make.bottom.equalTo(self.mas_bottom).offset(-self.insetVertical);
                make.trailing.equalTo(self.mas_trailing);
            }
            else if (idx == BDividerViewDirectionBottom) {
                make.bottom.equalTo(self.mas_bottom);
                make.leading.equalTo(self.mas_leading).offset(self.insetHorizontal);
                make.trailing.equalTo(self.mas_trailing).offset(-self.insetHorizontal);
            }
            else if (idx == BDividerViewDirectionLeft) {
                make.top.equalTo(self.mas_top).offset(self.insetVertical);
                make.bottom.equalTo(self.mas_bottom).offset(-self.insetVertical);
                make.leading.equalTo(self.mas_leading);
            }
        }];
    }];
    
    [self updateThicknessConstraints];
}

- (void)updateThicknessConstraints
{
    [self.dividerViews enumerateObjectsUsingBlock:^(UIView *dividerView, NSUInteger idx, BOOL *stop) {
        [dividerView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (idx == BDividerViewDirectionTop || idx == BDividerViewDirectionBottom) {
                make.height.mas_equalTo(self.thickness);
            }
            else if (idx == BDividerViewDirectionRight || idx == BDividerViewDirectionLeft) {
                make.width.mas_equalTo(self.thickness);
            }
        }];
    }];
}

- (void)updateDividerViews
{
    [self.dividerViews enumerateObjectsUsingBlock:^(UIView *dividerView, NSUInteger idx, BOOL *stop) {
        dividerView.hidden = (self.option & (1 << idx)) == 0;
    }];
}

#pragma mark - Accessors

- (void)setOption:(BDividerViewOption)option
{
    if (_option == option)
        return;
    
    _option = option;
    [self.dividerViews enumerateObjectsUsingBlock:^(UIView *dividerView, NSUInteger idx, BOOL *stop) {
        dividerView.hidden = (self.option & (1 << idx)) == 0;
    }];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self.dividerViews enumerateObjectsUsingBlock:^(UIView *dividerView, NSUInteger idx, BOOL *stop) {
        dividerView.backgroundColor = color;
    }];
}

- (void)setThickness:(CGFloat)thickness
{
    if (_thickness == thickness)
        return;
    
    _thickness = thickness;
    [self updateThicknessConstraints];
    [self setNeedsUpdateConstraints];
}

@end
