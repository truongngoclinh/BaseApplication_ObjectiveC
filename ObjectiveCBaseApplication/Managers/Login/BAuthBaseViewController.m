//
//  BAuthBaseViewController.m
//  Cyberpay
//
//  Created by Linh on 4/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BAuthBaseViewController.h"

#import "UIScrollView+BFitSize.h"  

#import "BClientRoleDefine.h"

@interface BAuthBaseViewController ()

@property (nonatomic, strong) UIImageView *profileIconViewContainer;

@property (nonatomic, strong) UIView *navigationBarBackgoundView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) BFlippableImageView *profileIconView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation BAuthBaseViewController

+ (UIImage *)imageForRole:(NSString *)role
{
    UIImage *image;
    
    if ([role isEqualToString:BClientRole1]){
        image = [UIImage imageNamed:@"account_head_icon_boss"];
    } else if ([role isEqualToString:BClientRole2]) {
        image = [UIImage imageNamed:@"account_head_icon_seller"];
    } else {
        NSAssert(NO, @"Not Supported!");
    }
    return image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.navigationBarBackgoundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationBarBackgoundView.backgroundColor = [BTheme navigationBarColor];
    [self.view addSubview:self.navigationBarBackgoundView];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.backButton setImage:[UIImage imageNamed:@"element_titlebar_icon_arrow_left2"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.backButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
    self.backButton.alpha = 0.0;
    [self.navigationBarBackgoundView addSubview:self.backButton];
    
    self.profileIconViewContainer = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.profileIconViewContainer.image = [UIImage imageNamed:@"login_titlebar_head_bg"];
    [self.navigationBarBackgoundView addSubview:self.profileIconViewContainer];
    
    // Put icon in a separate view, because the flip will affect layers in the same superview.
    CGFloat cornerRadius = BX(kProfileIconViewContainerSize - kProfileIconInset * 2) / 2;
    self.profileIconView = [[BFlippableImageView alloc] initWithFrame:CGRectZero
                                                  imageBackgroundColor:[UIColor b_colorWithHex:@"ecf2fc"]
                                                          cornerRadius:cornerRadius];
    [self.profileIconView setImage:[BAuthBaseViewController imageForRole:BClientRole1] animated:NO]; // Default
    [self.profileIconViewContainer addSubview:self.profileIconView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];

    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.hintLabel.font = [BTheme lightFontOfSize:BX(14)];
    self.hintLabel.textColor = [BTheme textColor];
    self.hintLabel.textAlignment = NSTextAlignmentLeft;
    self.hintLabel.numberOfLines = 2;
    [self.scrollView addSubview:self.hintLabel];
    
    [self.scrollView b_fitScrollViewWidth];
    [self automaticallyAdjustsScrollViewInsetsForKeyboardChange:self.scrollView usingBottomLayoutGuide:YES];
    
    [self.view bringSubviewToFront:self.navigationBarBackgoundView];
    
    [self configureConstraintsForSuper];
}

- (void)configureConstraintsForSuper
{
    [self.navigationBarBackgoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(BX(74));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBarBackgoundView.mas_top).offset(BX(29));
        make.leading.equalTo(self.navigationBarBackgoundView.mas_leading).offset(BX(3));
        make.size.mas_equalTo(BXSize(CGSizeMake(40, 40)));
    }];
    
    [self.profileIconViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationBarBackgoundView.mas_centerX);
        make.centerY.equalTo(self.navigationBarBackgoundView.mas_bottom).offset(BX(-4));
        make.size.mas_equalTo(BXSize(CGSizeMake(kProfileIconViewContainerSize, kProfileIconViewContainerSize)));
    }];
    
    CGFloat padding = BX(kProfileIconInset);
    [self.profileIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.profileIconViewContainer).insets(UIEdgeInsetsMake(padding, padding, padding, padding));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBarBackgoundView.mas_bottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
    }];
}

#pragma mark - BLoginNavigationAnimationProtocol

- (void)prepareAnimationForTransitionType:(kLoginNavigationAnimationType)type
{
    // To be implemented by subclasses.
}

- (void)performAnimationForTransitionType:(kLoginNavigationAnimationType)type
{
    // To be implemented by subclasses.
}

- (void)didFinishAnimationForTransitionType:(kLoginNavigationAnimationType)type
{
    // To be implemented by subclasses.
}

#pragma mark - Actions

- (void)didTapBackButton:(UIButton *)sender
{
    // To be implemented by subclasses.
}

#pragma mark - Helper

- (NSAttributedString *)attributedStringForMobile:(NSString *)mobile
{
    NSString *hintLabelTextPlain = [NSString stringWithFormat:TXT(@"label_otp_sent"), mobile];
    NSMutableAttributedString * hintLabelTextBold = [[NSMutableAttributedString alloc] initWithString:hintLabelTextPlain];
    NSRange boldedRange = NSMakeRange(hintLabelTextPlain.length - mobile.length, mobile.length);
    [hintLabelTextBold beginEditing];
    [hintLabelTextBold addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"Helvetica" size:BX(14)]
                              range:boldedRange];
    [hintLabelTextBold endEditing];
    
    return hintLabelTextBold;
}

#pragma mark - BViewController

- (BOOL)automaticallyHidesNavigationBar
{
    return YES;
}

@end
