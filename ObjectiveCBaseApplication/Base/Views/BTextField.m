//
//  BTextField.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 30/1/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BTextField.h"
#import "BNumberPad.h"

#import "UITextField+RightAlignedNoSpaceFix.h"

@interface BTextField () <BNumberPadDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) BNumberPad *numberPad;

@property (nonatomic, assign) BOOL shouldScale;

@end

@implementation BTextField

- (CGSize)intrinsicContentSize
{
    UIImage *image = self.backgroundImageView.image;
    CGSize size = [super intrinsicContentSize];
    
    if (image) {
        return CGSizeMake(size.width, [self scaleIfNeeded:image.size.height]);
    } else {
        return CGSizeMake(size.width, [self scaleIfNeeded:40]);
    }
}

- (BNumberPad *)numberPad
{
    if (!_numberPad) {
        _numberPad = [[BNumberPad alloc] initWithFrame:CGRectMake(0, 0, 1, [BNumberPad requiredHeight])];
        _numberPad.delegate = self;
    }
    return _numberPad;
}

+ (UIImage *)backgroundImageForStyle:(BTextFieldStyle)style
{
    UIImage *image;
    switch (style) {
        case BTextFieldStyleDefault:
            break;
        case BTextFieldStyleInputSmall:
            image = [[UIImage imageNamed:@"inputFrame_small"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 8, 5, 8)
                                                                                resizingMode:UIImageResizingModeStretch];
            break;
        case BTextFieldStyleInputNew:
            break;
        default:
            NSAssert(NO, @"Not Supported");
            break;
    }
    return image;
}

+ (UIImage *)selectedBackgroundImageForStyle:(BTextFieldStyle)style
{
    UIImage *image;
    switch (style) {
        case BTextFieldStyleDefault:
            break;
        case BTextFieldStyleInputSmall:
            image = [[UIImage imageNamed:@"inputFrame_small_activate"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 8, 5, 8)
                                                                                      resizingMode:UIImageResizingModeStretch];
            break;
        case BTextFieldStyleInputNew:
            break;
        default:
            NSAssert(NO, @"Not Supported");
            break;
    }
    return image;
}

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _shouldScale = YES;
        [self b_enableRightAlignedNoSpaceFix];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _shouldScale = YES;
        [self b_enableRightAlignedNoSpaceFix];
    }
    return self;
}

- (instancetype)initWithStyle:(BTextFieldStyle)style
{
    self = [self initWithStyle:style shouldScale:YES];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithStyle:(BTextFieldStyle)style shouldScale:(BOOL)shouldScale
{
    self = [super initWithFrame:CGRectZero];

    if (self) {
        _shouldScale = shouldScale;
        [self setUpPropertiesWithStyle:style];
    }
    return self;
}

// Helper
- (void)setUpPropertiesWithStyle:(BTextFieldStyle)style
{
    _style = style;
    
    _contentInset = UIEdgeInsetsMake(0, [self scaleIfNeeded:4], 0, [self scaleIfNeeded:4]);
    _placeholderAttributes = @{ NSForegroundColorAttributeName : [BTheme textColorLightest]};
    
    if (self.style == BTextFieldStyleInputNew) {
        self.layer.borderColor = [UIColor b_colorWithHex:@"bcc6cb"].CGColor;
        self.layer.borderWidth = [self scaleIfNeeded:1];
        self.layer.cornerRadius = [self scaleIfNeeded:2];
    } else {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[BTextField backgroundImageForStyle:style]];
        _backgroundImageView.frame = self.bounds;
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundImageView];
    }
    
    [self b_enableRightAlignedNoSpaceFix];
    
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    if (self.clearButton) {
        CGFloat x = CGRectGetWidth(self.bounds) - self.contentInset.right - CGRectGetWidth(self.clearButton.frame)/2;
        self.clearButton.center = CGPointMake(x, CGRectGetMidY(self.bounds));
    }
    [super layoutSubviews];
}

#pragma mark - Setters

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    [super setKeyboardType:keyboardType];
    
    if (keyboardType == UIKeyboardTypeNumberPad) {
        self.inputView = self.numberPad;
    } else {
        self.inputView = nil;
    }
}

- (void)setShowDecimalSymbol:(BOOL)showDecimalSymbol
{
    self.numberPad.showDecimalSymbol = showDecimalSymbol;
}

- (BOOL)showDecimalSymbol
{
    return self.numberPad.showDecimalSymbol;
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode
{
    if (clearButtonMode == UITextFieldViewModeWhileEditing) {
        if (!self.clearButton) {
            UIImage *image = [UIImage imageNamed:@"element_inputbox_icon_clean"];
            self.clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [self scaleIfNeeded:image.size.width], [self scaleIfNeeded:image.size.height])];
            self.clearButton.exclusiveTouch = YES;
            [self.clearButton setBackgroundImage:image forState:UIControlStateNormal];
            [self.clearButton addTarget:self action:@selector(didTapClearButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.clearButton];
            [self updateClearButton];
            [self setNeedsLayout];
        }
    }
    else {
        if (self.clearButton) {
            [self.clearButton removeFromSuperview];
            self.clearButton = nil;
            [self setNeedsLayout];
        }
        [super setClearButtonMode:clearButtonMode];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundImageView.image = [BTextField selectedBackgroundImageForStyle:self.style];
    } else {
        self.backgroundImageView.image = [BTextField backgroundImageForStyle:self.style];
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    if (UIEdgeInsetsEqualToEdgeInsets(_contentInset, contentInset))
        return;
    
    _contentInset = contentInset;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (NSRange)selectedRange
{
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];
    return NSMakeRange(location, length);
}


// Note: The below approach doesn't change the font size in iOS 7

- (void)setPlaceholder:(NSString *)placeholder
{
    NSAttributedString *attributedPlaceholder = nil;
    if (placeholder) {
        if (self.placeholderAttributes) {
            attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:self.placeholderAttributes];
        } else {
            attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder];
        }
    }
    self.attributedPlaceholder = attributedPlaceholder;
}

#pragma mark - Clear

- (void)didTapClearButton:(UIButton *)button
{
    self.text = @"";
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (void)updateClearButton
{
    self.clearButton.hidden = (self.text.length == 0);
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self updateClearButton];
}

#pragma mark - UITextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    UIEdgeInsets inset = self.contentInset;
    if (self.clearButton) {
        inset.right += CGRectGetWidth(self.clearButton.frame);
    }
    return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], inset);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    if (self.hideCursor) {
        return CGRectZero;
    }
    return [super caretRectForPosition:position];
}

#pragma mark - BNumberPadDelegate

- (void)numberPadDidTapBackspace:(BNumberPad *)numberPad
{
    BOOL shouldChange = YES;
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        
        NSRange range = [self selectedRange];
        if (self.selectedTextRange.isEmpty && range.location > 0) {
            range.location--;
        }
        shouldChange = [self.delegate textField:self shouldChangeCharactersInRange:[self selectedRange] replacementString:@""];
    }
    
    if (shouldChange) {
        [self deleteBackward];
    }
}

- (void)numberPad:(BNumberPad *)numberPad didTapKey:(NSString *)key
{
    BOOL shouldChange = YES;
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        shouldChange = [self.delegate textField:self shouldChangeCharactersInRange:[self selectedRange] replacementString:key];
    }
    
    if (shouldChange) {
        [self insertText:key];
    }
}

#pragma mark - Getters

- (NSString *)textNotAffectedByRightAlignFix
{
    if (self.textAlignment == NSTextAlignmentRight) {
        return [self b_textNotAffectedByFix];
    } else {
        return self.text;
    }
}

#pragma mark - Utility

- (CGFloat)scaleIfNeeded:(CGFloat)size
{
    if (self.shouldScale) {
        return BX(size);
    } else {
        return size;
    }
}

@end
