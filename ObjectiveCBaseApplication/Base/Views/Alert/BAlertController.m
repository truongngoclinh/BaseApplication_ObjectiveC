//
//  BAlertController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BAlertController.h"
#import "BAlertAnimator.h"

#import "UIView+BView.h"
#import "BTKeyboardNotifier.h"

static const CGFloat kAlertViewCornerRadius = 7;

@interface BAlertControllerAction : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) BAlertControllerBlock block;

+ (BAlertControllerAction *)actionWithTitle:(NSString *)title block:(BAlertControllerBlock)block;

@end

static const NSInteger kMaxActionCount = 2;

@interface BAlertController () <UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, BTKeyboardNotifier>

@property (nonatomic, strong) BAlertAnimator *animator;
@property (nonatomic, strong) NSMutableArray *actions;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *alertBackgroundView; // For corner radius and background color
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, assign) BOOL allowsTapToDismiss;

@end

@implementation BAlertController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        
        _offset = CGPointMake(0, 0);
        _actions = [NSMutableArray array];
        _animator = [[BAlertAnimator alloc] init];
        
        [[BTKeyboardNotifier sharedInstance] addDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.alertView];
    
    if (self.centerIconImage) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.iconView.image = self.centerIconImage;
        [self.alertView addSubview:self.iconView];
    }
    
    self.alertBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.alertBackgroundView.userInteractionEnabled = YES;
    self.alertBackgroundView.backgroundColor = [UIColor whiteColor];
    self.alertBackgroundView.clipsToBounds = YES;
    self.alertBackgroundView.layer.cornerRadius = kAlertViewCornerRadius;
    [self.alertView addSubview:self.alertBackgroundView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.alertBackgroundView addSubview:self.contentView];
    
    if (self.customView) {
        [self.contentView addSubview:self.customView];
    }
    
    if (self.actions.count) {
        self.dividerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.dividerView.backgroundColor = [BTheme dividerColor];
        [self.alertBackgroundView addSubview:self.dividerView];
    }
    
    NSMutableArray *buttons = [NSMutableArray array];
    [self.actions enumerateObjectsUsingBlock:^(BAlertControllerAction *action, NSUInteger idx, BOOL *stop) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        button.tag = idx;
        button.exclusiveTouch = YES;
        button.titleLabel.font = [BTheme lightFontOfSize:18];
        button.backgroundColor = [BTheme backgroundColor];
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor cp_colorWithHex:@"488cf4"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor cp_colorWithHex:@"6ec9ff"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(didTapActionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:button];
        [self.alertBackgroundView addSubview:button];
        
        if (idx > 0) {
            [button cp_addDividerAtPosition:BViewDividerPositionLeft
                                      color:[UIColor cp_colorWithHex:@"E6EAF1"]
                                  thickness:0.5
                                      inset:UIEdgeInsetsMake(13, 0, 13, 0)];
        }
    }];
    self.buttons = [buttons copy];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    self.allowsTapToDismiss = self.allowsTapToDismissWhenHaveButton || self.buttons.count == 0;
    
    [self baseConfigureConstraints];
    
    [self.alertView bringSubviewToFront:self.iconView];
}

- (void)baseConfigureConstraints
{
    if (self.iconView) {
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.alertView.mas_top).offset(5);
            make.centerX.equalTo(self.alertView.mas_centerX);
        }];
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertBackgroundView.mas_top);
        make.leading.equalTo(self.alertBackgroundView.mas_leading);
        make.trailing.equalTo(self.alertBackgroundView.mas_trailing);
    }];
    
    if (self.customView) {
        [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.customView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1
                                                         forAxis:UILayoutConstraintAxisVertical];
        [self.customView setContentHuggingPriority:UILayoutPriorityDefaultLow + 1
                                           forAxis:UILayoutConstraintAxisVertical];
    }
    
    __block UIView *lastView = self.contentView;
    
    if (self.dividerView) {
        [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom);
            make.leading.equalTo(self.contentView.mas_leading);
            make.trailing.equalTo(self.contentView.mas_trailing);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (idx == 0) {
                make.top.equalTo(self.dividerView.mas_bottom);
                make.height.mas_equalTo(58);
                make.leading.equalTo(self.alertView.mas_leading);
            } else {
                make.top.equalTo(lastView.mas_top);
                make.bottom.equalTo(lastView.mas_bottom);
                make.leading.equalTo(lastView.mas_trailing);
                make.width.equalTo(lastView.mas_width);
            }
            
            if (idx == self.buttons.count - 1) {
                make.trailing.equalTo(self.alertView.mas_trailing);
            }
        }];
        lastView = button;
    }];
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.alertBackgroundView.mas_bottom);
    }];
    
    [self configureAlertViewContstraintsWithVerticalOffset:self.offset];
    
    [self.alertBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.alertView);
    }];
}

- (void)configureAlertViewContstraintsWithVerticalOffset:(CGPoint)offset
{
    [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(self.offset.x).offset(offset.x);
        make.centerY.equalTo(self.view.mas_centerY).offset(self.offset.y).offset(offset.y);
        make.width.equalTo(self.view.mas_width).offset(-56);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Fixed issue with wrong content inset when becoming first responder in viewWillAppear.
    [self.view layoutIfNeeded];
    
    if ([self.delegate respondsToSelector:@selector(shouldBecomeFirstResponderWhenViewWillAppearForAlertController:)]) {
        if ([self.delegate shouldBecomeFirstResponderWhenViewWillAppearForAlertController:self]) {
            [self.customView becomeFirstResponder];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.customView resignFirstResponder];
}

- (void)addActionTitle:(NSString *)title onTriggered:(BAlertControllerBlock)triggeredBlock
{
    NSParameterAssert(!self.isViewLoaded);
    NSParameterAssert(self.actions.count < kMaxActionCount);
    [self.actions addObject:[BAlertControllerAction actionWithTitle:title block:triggeredBlock]];
}

#pragma mark - Actions

- (void)didTapActionButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(alertController:shouldTriggerForIndex:)]) {
        if (![self.delegate alertController:self shouldTriggerForIndex:button.tag]) {
            return;
        }
    }
    
    BAlertControllerAction *action = self.actions[button.tag];
    [self dismissViewControllerAnimated:YES completion:^{
        if (action.block) action.block();
    }];
}

- (void)didTapView:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.customView isFirstResponder]) {
        [self.customView resignFirstResponder];
    } else if (self.allowsTapToDismiss) {
        BWeakify(self, me);
        [self dismissViewControllerAnimated:YES completion:^{
            if ([me.delegate respondsToSelector:@selector(didDismissAlertController:)]) {
                [me.delegate didDismissAlertController:me];
            }
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animator.isPresenting = YES;
    return self.animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animator.isPresenting = NO;
    return self.animator;
}

#pragma mark - BTKeyboardNotifier

- (void)keyboardWillShowWithRect:(CGRect)rect
                        duration:(CGFloat)duration
                animationOptions:(UIViewAnimationOptions)animationOptions
{
    CGFloat translation = [self alertViewTranslationWhenKeyboardIsShownWithKeyboardHeight:CGRectGetHeight(rect)];
    
    [self configureAlertViewContstraintsWithVerticalOffset:CGPointMake(0, translation)];
    [self.view setNeedsLayout];
    
    [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHideWithRect:(CGRect)rect
                        duration:(CGFloat)duration
                animationOptions:(UIViewAnimationOptions)animationOptions
{
    [self configureAlertViewContstraintsWithVerticalOffset:self.offset];
    [self.view setNeedsLayout];
    
    [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (CGFloat)alertViewTranslationWhenKeyboardIsShownWithKeyboardHeight:(CGFloat)keyboardHeight
{
    CGFloat alertPaddingVertical = (CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.alertView.frame))/2;
    CGFloat translation = alertPaddingVertical - keyboardHeight;
    CGFloat minTranslation = -(alertPaddingVertical - 20);
    
    if (translation < minTranslation) {
        translation = minTranslation;
    }
    
    return translation;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.allowsTapToDismiss || self.customView.isFirstResponder;
}

@end

@implementation BAlertControllerAction

+ (BAlertControllerAction *)actionWithTitle:(NSString *)title block:(BAlertControllerBlock)block
{
    return [[self alloc] initWithTitle:title block:block];
}

- (instancetype)initWithTitle:(NSString *)title block:(BAlertControllerBlock)block
{
    self = [super init];
    if (self) {
        _title = title;
        _block = block;
    }
    return self;
}

@end
