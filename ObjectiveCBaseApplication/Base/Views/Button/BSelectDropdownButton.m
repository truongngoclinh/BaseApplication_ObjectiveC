//
//  BSelectDropdownButton.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BSelectDropdownButton.h"

@interface BSelectDropdownButton ()

@property (nonatomic, strong) UIImageView *dropdownArrow;

@end

@implementation BSelectDropdownButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.titleEdgeInsets = (UIEdgeInsets){.left = BX(10)};

        self.dropdownArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ele_ic_dropdown"]];
        [self addSubview:self.dropdownArrow];

        [self configureConstraints];
    }

    return self;
}

- (void)configureConstraints
{
    [self.dropdownArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(BX(-10));
        make.centerY.equalTo(self.mas_centerY);
        BXMasImage(self.dropdownArrow.image);
    }];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
