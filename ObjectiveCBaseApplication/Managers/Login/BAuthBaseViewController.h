//
//  BAuthBaseViewController.h
//  Cyberpay
//
//  Created by Linh on 4/8/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

typedef NS_ENUM(NSInteger, BAuthViewControllerPosition)
{
    BAuthViewControllerPositionNormal  = 0,
    BAuthViewControllerPositionLeft    = 1,
    BAuthViewControllerPositionRight   = 2,
    BAuthViewControllerPositionCompact = 3,
    BAuthViewControllerPositionLoose   = 4
};

#import "BViewController.h"
#import "BLoginNavigationAnimationProtocol.h"
#import "BFlippableImageView.h"

static CGFloat const kLanscapeInsets = 13;
static CGFloat const kTopDistanceHintLabel = 65;
static CGFloat const kTopDistanceFirstTextField = 91;
static CGFloat const kTopDistanceContinueButtonRegisterVCLoose = 300;
static CGFloat const kButtonGap = 16;
static CGFloat const kButtonGapRegisterVC = 10;

static CGFloat const kProfileIconViewContainerSize = 90;
static CGFloat const kProfileIconInset = 8;

@interface BAuthBaseViewController : BViewController <BLoginNavigationAnimationProtocol>

@property (nonatomic, strong, readonly) UIView *navigationBarBackgoundView;
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong, readonly) BFlippableImageView *profileIconView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UILabel *hintLabel;

+ (UIImage *)imageForRole:(NSString *)role;

- (void)didTapBackButton:(UIButton *)sender;

- (NSAttributedString *)attributedStringForMobile:(NSString *)mobile;

@end
