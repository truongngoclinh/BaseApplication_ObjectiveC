//
//  BInputAccessoryView.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 2/2/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BInputAccessoryView.h"
#import "UIView+BView.h"

@interface BInputAccessoryView ()

@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation BInputAccessoryView

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, BX(40));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor b_colorWithHex:@"fdfdfe"];
        _doneButtonTitle = TXT(@"button_done");
        
        _arrowButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_arrowButton setImage:[UIImage imageNamed:@"ele_ic_dropdown"] forState:UIControlStateNormal];
        [_arrowButton addTarget:self action:@selector(didTapArrowButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_arrowButton];
        
        _doneButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _doneButton.titleLabel.font = [BTheme lightFontOfSize:BX(18)];
        [_doneButton setTitleColor:[BTheme textColor] forState:UIControlStateNormal];
        [_doneButton setTitle:_doneButtonTitle forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(didTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneButton];
        
        [self b_addDividerAtPosition:BViewDividerPositionTop color:[UIColor b_colorWithHex:@"e9e9e9"] thickness:BX(1)];
        
        [self configureConstraints];
    }
    return self;
}

- (void)configureConstraints
{
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(self.mas_leading);
        make.width.equalTo(self.mas_width).dividedBy(3);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.trailing.equalTo(self.mas_trailing);
        make.width.equalTo(self.mas_width).dividedBy(3);
    }];
}

- (void)setHideArrow:(BOOL)hideArrow
{
    _hideArrow = hideArrow;
    self.arrowButton.hidden = hideArrow;
}

- (void)setDoneEnabled:(BOOL)doneEnabled
{
    self.doneButton.enabled = doneEnabled;
}

- (BOOL)doneEnabled
{
    return self.doneButton.enabled;
}

#pragma mark - Actions

- (void)didTapArrowButton:(UIButton *)button
{
    [self.delegate inputAccessoryViewDidTapArrow:self];
}

- (void)didTapDoneButton:(UIButton *)button
{
    [self.delegate inputAccessoryViewDidTapDone:self];
}

#pragma mark - Accessors

- (void)setDoneButtonTitle:(NSString *)doneButtonTitle
{
    _doneButtonTitle = doneButtonTitle;
    [self.doneButton setTitle:_doneButtonTitle forState:UIControlStateNormal];
}

@end
