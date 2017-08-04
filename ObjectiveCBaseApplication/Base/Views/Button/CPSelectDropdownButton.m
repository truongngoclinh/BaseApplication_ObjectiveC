//
//  CPSelectDropdownButton.m
//  Cyberpay
//
//  Created by LABS-LEES-MAC on 30/7/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import "CPSelectDropdownButton.h"

@interface CPSelectDropdownButton ()

@property (nonatomic, strong) UIImageView *dropdownArrow;

@end

@implementation CPSelectDropdownButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.titleEdgeInsets = (UIEdgeInsets){.left = CPX(10)};

        self.dropdownArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ele_ic_dropdown"]];
        [self addSubview:self.dropdownArrow];

        [self configureConstraints];
    }

    return self;
}

- (void)configureConstraints
{
    [self.dropdownArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(CPX(-10));
        make.centerY.equalTo(self.mas_centerY);
        CPXMasImage(self.dropdownArrow.image);
    }];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
