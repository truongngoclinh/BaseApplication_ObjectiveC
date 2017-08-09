//
//  BLoginViewController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/9/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BLoginViewController.h"
#import "BSolidButton.h"
#import "BLoginTextField.h"

@interface BLoginViewController ()

@property (strong, nonatomic) BSolidButton *mLoginButton;
@property (strong, nonatomic) BLoginTextField *mLoginTextField;

@end

@implementation BLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self configureConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma views

- (void)initViews
{
    self.mLoginTextField = [[BLoginTextField alloc] init];
    self.mLoginTextField.placeholder = TXT(@"label_login_placeholder");
    self.mLoginTextField.textAlignment = NSTextAlignmentLeft;
    self.mLoginTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.mLoginTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:self.mLoginTextField];
   
    self.mLoginButton = [[BSolidButton alloc] initWithStyle:BSolidButtonStyleMain];
    [self.mLoginButton setTitle:TXT(@"label_login") forState:UIControlStateNormal];
    [self.mLoginButton addTarget:self action:@selector(didTabLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.mLoginButton];
}

# pragma constraints

- (void)configureConstraints
{
    [self.mLoginTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(kTopDistanceFirstTextField);
        make.leading.equalTo(self.scrollView.mas_leading).offset(BThemePaddingDefault);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-BThemePaddingDefault);
        make.height.mas_equalTo(BThemeTextFieldHeightDefault);
    }];
   
    [self.mLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mLoginTextField.mas_bottom).offset(BThemeDefaultMarginTop);
        make.centerX.equalTo(self.mLoginTextField.mas_centerX);
        make.leading.equalTo(self.mLoginTextField.mas_leading);
        make.trailing.equalTo(self.mLoginTextField.mas_trailing);
        make.height.mas_equalTo(BThemeButtonHeightDefault);
    }];
}

# pragma actions

- (void)didTabLoginButton:(UIButton *)button
{
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
}

@end
