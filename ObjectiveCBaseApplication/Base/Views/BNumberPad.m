//
//  BNumberPad.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 17/3/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BNumberPad.h"
#import "BNumberFormatter.h"
#import "BCountryLogic.h"

static const NSInteger kNumberOfColumn = 3;

@interface BNumberPad () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *verticalDividers;
@property (nonatomic, strong) NSArray *horizontalDividers;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *backspaceButton;
@property (nonatomic, strong) UIButton *decimalButton;

@end

@implementation BNumberPad


+ (CGFloat)requiredHeight
{
    return BX(216);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *buttons = [NSMutableArray array];
        
        UIImage *backgroundImage = [BTheme imageForColor:[UIColor b_colorWithHex:@"fdfdfe"]];
        UIImage *highlightedBackgroundImage = [BTheme imageForColor:[UIColor b_colorWithHex:@"eceff1"]];
        
        for (int i = 1; i <= 10; i++) {
            int keypadNumber = i%10; // 1-9, 0
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
            button.titleLabel.font = [BTheme lightFontOfSize:BX(26)];
            [button setTitle:[NSString stringWithFormat:@"%d", keypadNumber] forState:UIControlStateNormal];
            [button setTitleColor:[BTheme textColor] forState:UIControlStateNormal];
            [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
            [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttons addObject:button];
        }
        
        // Empty
        self.decimalButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.decimalButton.enabled = NO;
        self.decimalButton.titleLabel.font = [BTheme lightFontOfSize:BX(26)];
        [self.decimalButton setTitle:[[[BNumberFormatter alloc] init] decimalSeparator] forState:UIControlStateNormal];
        [self.decimalButton setTitle:@"" forState:UIControlStateDisabled];
        [self.decimalButton setTitleColor:[BTheme textColor] forState:UIControlStateNormal];
        [self.decimalButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self.decimalButton setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
        [self.decimalButton setBackgroundImage:backgroundImage forState:UIControlStateDisabled];
        [self.decimalButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.decimalButton];
        [buttons insertObject:self.decimalButton atIndex:9];
        
        // Backspace
        self.backspaceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.backspaceButton setImage:[UIImage imageNamed:@"icon_backspace"] forState:UIControlStateNormal];
        [self.backspaceButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self.backspaceButton setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
        [self.backspaceButton setBackgroundImage:highlightedBackgroundImage forState:UIControlStateSelected];
        [self.backspaceButton setBackgroundImage:highlightedBackgroundImage forState:UIControlStateSelected | UIControlStateHighlighted];
        [self.backspaceButton addTarget:self action:@selector(didTapBackspaceButton:) forControlEvents:UIControlEventTouchDown];
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        gesture.allowableMovement = 100;
        [self.backspaceButton addGestureRecognizer:gesture];

        [self addSubview:self.backspaceButton];
        [buttons addObject:self.backspaceButton];
        _buttons = [buttons copy];
        
        UIColor *dividerColor = [BTheme dividerColor];
        
        // Horizontal Dividers
        NSMutableArray *horizontalDividers = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIView *divider = [[UIView alloc] initWithFrame:CGRectZero];
            divider.backgroundColor = dividerColor;
            [self addSubview:divider];
            [horizontalDividers addObject:divider];
        }
        _horizontalDividers = [horizontalDividers copy];
        
        // Vertical Dividers
        NSMutableArray *verticalDividers = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIView *divider = [[UIView alloc] initWithFrame:CGRectZero];
            divider.backgroundColor = dividerColor;
            [self addSubview:divider];
            [verticalDividers addObject:divider];
        }
        _verticalDividers = [verticalDividers copy];
        
        [self configureConstraints];
    }
    return self;
}

- (void)configureConstraints
{
    NSInteger lastRow = (self.buttons.count - 1)/kNumberOfColumn;
    NSInteger lastCol = kNumberOfColumn - 1;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        
        NSInteger col = idx%kNumberOfColumn;
        NSInteger row = idx/kNumberOfColumn;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (idx > 0) {
                UIButton *prevbutton = self.buttons[idx - 1];
                make.size.equalTo(prevbutton);
            }
            
            if (col == 0) {
                make.leading.equalTo(self.mas_leading);
            } else {
                UIButton *leftButton = self.buttons[idx - 1];
                make.leading.equalTo(leftButton.mas_trailing);
            }
            
            if (col == lastCol) {
                make.trailing.equalTo(self.mas_trailing);
            }
            
            if (row == 0) {
                make.top.equalTo(self.mas_top);
            } else {
                UIButton *topButton = self.buttons[idx - kNumberOfColumn];
                make.top.equalTo(topButton.mas_bottom);
            }
            
            if (row == lastRow) {
                make.bottom.equalTo(self.mas_bottom);
            }
        }];
    }];
    
    NSInteger numberOfRows = self.buttons.count/kNumberOfColumn;
    [self.horizontalDividers enumerateObjectsUsingBlock:^(UIView *divider, NSUInteger idx, BOOL *stop) {
        [divider mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (idx > 0) {
                make.top.equalTo(self.mas_bottom).multipliedBy((float)idx/numberOfRows);
            } else {
                make.top.equalTo(self.mas_top);
            }
            make.leading.equalTo(self.mas_leading);
            make.trailing.equalTo(self.mas_trailing);
            make.height.mas_equalTo(BX(0.5));
        }];
    }];
    
    [self.verticalDividers enumerateObjectsUsingBlock:^(UIView *divider, NSUInteger idx, BOOL *stop) {
        [divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.leading.equalTo(self.mas_trailing).multipliedBy((float)(idx+1)/kNumberOfColumn);
            make.width.mas_equalTo(BX(0.5));
        }];
    }];
}

- (void)didLongPress:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self startTimer];
        self.backspaceButton.selected = YES;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
             gestureRecognizer.state == UIGestureRecognizerStateFailed ||
             gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [self stopTimer];
        self.backspaceButton.selected = NO;
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(triggerTimer)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)triggerTimer
{
    [self.delegate numberPadDidTapBackspace:self];
}

- (void)didTapButton:(UIButton *)button
{
    [self.delegate numberPad:self didTapKey:[button titleForState:UIControlStateNormal]];
}

- (void)didTapBackspaceButton:(UIButton *)button
{
    [self.delegate numberPadDidTapBackspace:self];
}

#pragma mark - Accessors

//- (void)setShowDecimalSymbol:(BOOL)showDecimalSymbol
//{
//    if ([BCountryLogic currentCountryLogic].decimalSymbolInputEnabled) {
//        self.decimalButton.enabled = showDecimalSymbol;
//    }
//}

- (BOOL)showDecimalSymbol
{
    return self.decimalButton.enabled;
}

@end
