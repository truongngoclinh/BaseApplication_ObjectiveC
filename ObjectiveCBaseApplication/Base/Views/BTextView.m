//
//  BTextView.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 17/4/15.
//  Copyright (c) 2015 smvn. All rights reserved.
//

#import "BTextView.h"

#import "BNumberPad.h"

#import <objc/runtime.h>

#import "NSString+BAdditions.h"

static NSString *kNormalSpaceString = @" ";
static NSString *kNonBreakingSpaceString = @"\u00a0";

@interface BTextView () <BNumberPadDelegate, UITextViewDelegate>

@property (nonatomic, weak) id<UITextViewDelegate> externalDelegate;

@end

@implementation BTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(internalTextDidChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
        _placeholderColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
        
        _hidesPlaceholderWithEmptyTextWhenFirstResponder = YES;
        
        self.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    [super setKeyboardType:keyboardType];
    
    if (keyboardType == UIKeyboardTypeNumberPad) {
        BNumberPad *numberPad = [[BNumberPad alloc] initWithFrame:CGRectMake(0, 0, 1, [BNumberPad requiredHeight])];
        numberPad.delegate = self;
        self.inputView = numberPad;
    } else {
        self.inputView = nil;
    }
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
        shouldChange = [self.delegate textView:self shouldChangeTextInRange:[self selectedRange] replacementText:@""];
    }
    
    if (shouldChange) {
        [self deleteBackward];
    }
}

- (void)numberPad:(BNumberPad *)numberPad didTapKey:(NSString *)key
{
    BOOL shouldChange = YES;
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        shouldChange = [self.delegate textView:self shouldChangeTextInRange:[self selectedRange] replacementText:key];
    }
    
    if (shouldChange) {
        [self insertText:key];
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw placeholder:
    
    if (self.text.length == 0 && self.placeholder && (!self.isFirstResponder || !self.hidesPlaceholderWithEmptyTextWhenFirstResponder)) {
        // Inset the rect according to textContainer's inset.
        // Always use self.textContainerInset instead of self.contentInset
        rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
        
        // TODO: Placeholder is always 4.0 pt left of the actual content.
        // This is hacky. Not sure why this is the magic number
        rect.origin.x += 4.0f;
        rect.size.width -= 8.0f;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = self.textAlignment;
        
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSParagraphStyleAttributeName] = [paragraphStyle copy];
        if (self.font) attributes[NSFontAttributeName] = self.font;
        if (self.placeholderColor) attributes[NSForegroundColorAttributeName] = self.placeholderColor;
        
        [self.placeholder drawInRect:rect withAttributes:[attributes copy]];
    }
}

- (void)internalTextDidChanged:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

#pragma mark - UITextInputDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self replaceNormalSpacesWithNonBreakingSpaces];
    if ([self.externalDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.externalDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self replaceNormalSpacesWithNonBreakingSpaces];
    if ([self.externalDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.externalDelegate textViewDidChange:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self replaceNonBreakingSpacesWithNormalSpaces];
    [self removeLeadingAndTrailingWhitespaceAndNewlineCharacters];
    if ([self.externalDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.externalDelegate textViewDidEndEditing:textView];
    }
}

#pragma mark - Modifiers

- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    if (self.delegate) {
        self.externalDelegate = delegate;
    } else {
        super.delegate = delegate;
    }
}

#pragma mark - Replacement Logic

- (void)replaceNormalSpacesWithNonBreakingSpaces
{
    if (self.textAlignment == NSTextAlignmentRight) {
        
        NSUInteger distanceToEnd = [self offsetFromPosition:self.selectedTextRange.end
                                                 toPosition:self.endOfDocument];
        
        
        if (distanceToEnd == 0 && self.text.length) {
            
            self.text = [self.text stringByReplacingOccurrencesOfString:kNonBreakingSpaceString
                                                             withString:kNormalSpaceString
                                                                options:0
                                                                  range:NSMakeRange(0, self.text.length - 1)];
            
            self.text = [self.text stringByReplacingOccurrencesOfString:kNormalSpaceString
                                                             withString:kNonBreakingSpaceString
                                                                options:0
                                                                  range:NSMakeRange(self.text.length - 1, 1)];
        }
    }
}

- (void)replaceNonBreakingSpacesWithNormalSpaces
{
    if (self.textAlignment == NSTextAlignmentRight) {
        self.text = [self.text stringByReplacingOccurrencesOfString:kNonBreakingSpaceString
                                                         withString:kNormalSpaceString];
    }
}

- (void)removeLeadingAndTrailingWhitespaceAndNewlineCharacters
{
    self.text = [self.text b_stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters];
}

@end
