//
//  UITextField+RightAlignedNoSpaceFix.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//  http://stackoverflow.com/questions/19569688/right-aligned-uitextfield-spacebar-does-not-advance-cursor-in-ios-7/20129483#20129483

#import "UITextField+RightAlignedNoSpaceFix.h"

#import <objc/runtime.h>

#import "NSString+BAdditions.h"

@implementation UITextField (RightAlignedNoSpaceFix)

static NSString *kNormalSpaceString = @" ";
static NSString *kNonBreakingSpaceString = @"\u00a0";

static char BTextFieldRightAlignedNoSpaceFixIdentifier;

+(void)load
{
    [self b_swizzle:@selector(initWithCoder:) bSelector:@selector(initWithCoder_b_override:)];
    [self b_swizzle:@selector(initWithFrame:) bSelector:@selector(initWithFrame_b_override:)];
}

-(instancetype)initWithCoder_b_override:(NSCoder*)decoder
{
    self = [self initWithCoder_b_override:decoder];
    [self b_addSpaceFixActions];
    return self;
}

-(instancetype)initWithFrame_b_override:(CGRect)frame
{
    self = [self initWithFrame_b_override:frame];
    [self b_addSpaceFixActions];
    return self;
}

- (void)b_addSpaceFixActions
{
    [self addTarget:self
             action:@selector(b_textFieldDidBeginEditing)
   forControlEvents:UIControlEventEditingDidBegin];
    
    [self addTarget:self
             action:@selector(b_textFieldDidChangeEditing)
   forControlEvents:UIControlEventEditingChanged];
    
    [self addTarget:self
             action:@selector(b_textFieldDidEndEditing)
   forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - Actions

- (void)b_textFieldDidBeginEditing
{
    [self b_replaceNormalSpacesWithNonBreakingSpaces];
}

- (void)b_textFieldDidChangeEditing
{
    [self b_replaceNormalSpacesWithNonBreakingSpaces];
}

- (void)b_textFieldDidEndEditing
{
    [self b_replaceNonBreakingSpacesWithNormalSpaces];
    [self b_removeTrailingWhitespaces];
}

#pragma mark - Replacement Logic

- (void)b_replaceNormalSpacesWithNonBreakingSpaces
{
    if ([self b_shouldApplyFix]) {
        NSUInteger distanceToEnd = [self offsetFromPosition:self.selectedTextRange.end
                                                 toPosition:self.endOfDocument];
        if (distanceToEnd == 0) {
            self.text = [self.text stringByReplacingOccurrencesOfString:kNormalSpaceString
                                                             withString:kNonBreakingSpaceString];
        }
    }
}

- (void)b_replaceNonBreakingSpacesWithNormalSpaces
{
    if ([self b_shouldApplyFix]) {
        self.text = [self.text stringByReplacingOccurrencesOfString:kNonBreakingSpaceString
                                                         withString:kNormalSpaceString];
    }
}

- (void)b_removeTrailingWhitespaces
{
    self.text = [self.text b_stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
}

- (BOOL)b_shouldApplyFix
{
    return self.textAlignment == NSTextAlignmentRight && self.b_isFixEnabled;
}

#pragma mark - Utilities

+ (void)b_swizzle:(SEL)aSelector bSelector:(SEL)bSelector
{
    Method m1 = class_getInstanceMethod(self, aSelector);
    Method m2 = class_getInstanceMethod(self, bSelector);
    
    method_exchangeImplementations(m1, m2);
}

#pragma mark - Accessor

- (void)setCp_isFixEnabled:(BOOL)b_isFixEnabled
{
    objc_setAssociatedObject(self, &BTextFieldRightAlignedNoSpaceFixIdentifier, [NSNumber numberWithBool:b_isFixEnabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)b_isFixEnabled
{
    NSNumber *result = objc_getAssociatedObject(self, &BTextFieldRightAlignedNoSpaceFixIdentifier);
    if (result) {
        return [result boolValue];
    } else {
        return NO;
    }
}

- (NSString * _Nullable)b_textNotAffectedByFix
{
    return [self.text stringByReplacingOccurrencesOfString:kNonBreakingSpaceString
                                                withString:kNormalSpaceString];
}

#pragma mark - Enable/Disable

- (void)b_enableRightAlignedNoSpaceFix
{
    self.b_isFixEnabled = YES;
}

- (void)b_disableRightAlignedNoSpaceFix
{
    self.b_isFixEnabled = NO;
}

@end
