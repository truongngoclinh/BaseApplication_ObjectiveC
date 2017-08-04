//
//  BAlertInfoView.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import "BAlertInfoView.h"

@interface BAlertInfoView ()

@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation BAlertInfoView

+ (UIFont *)titleFont
{
    return [BTheme fontOfSize:18];
}

+ (UIFont *)detailFont
{
    return [BTheme lightFontOfSize:16];
}

+ (BAlertInfoView *)alertInfoViewWithTitle:(NSString *)title detail:(NSString *)detail
{
    return [BAlertInfoView alertInfoViewWithTitle:title detail:detail topOffset:0];
}

+ (BAlertInfoView *)alertInfoViewWithTitle:(NSString *)title
                                     detail:(NSString *)detail
                                  topOffset:(CGFloat)topOffset
{
    BAlertInfoView *alertView = [[self alloc] initWithFrame:CGRectZero];
    [alertView setTitle:title detail:detail topOffset:topOffset];
    
    return alertView;
}

+ (BAlertInfoView *)alertInfoViewWithAttributedTitle:(NSAttributedString *)attributedTitle attributedDetail:(NSAttributedString *)attributedDetail
{
    return [BAlertInfoView alertInfoViewWithAttributedTitle:attributedTitle
                                                      attributedDetail:attributedDetail
                                                   topOffset:0];
}


+ (BAlertInfoView *)alertInfoViewWithAttributedTitle:(NSAttributedString *)attributedTitle
                                     attributedDetail:(NSAttributedString *)attributedDetail
                                            topOffset:(CGFloat)topOffset
{
    BAlertInfoView *alertView = [[self alloc] initWithFrame:CGRectZero];
    [alertView setAttributedTitle:attributedTitle attributedDetail:attributedDetail topOffset:topOffset];
    
    return alertView;
}

#pragma mark - View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [BAlertInfoView titleFont];
        _titleLabel.textColor = [BTheme textColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _dividerView = [[UIView alloc] initWithFrame:CGRectZero];
        _dividerView.backgroundColor = [BTheme dividerColor];
        [self addSubview:_dividerView];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.font = [BAlertInfoView detailFont];
        _detailLabel.textColor = [BTheme textColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 0;
        [self addSubview:_detailLabel];
    }
    return self;
}

- (void)configureConstraintsWithTopOffset:(CGFloat)topOffset
{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(topOffset);
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        if (self.titleLabel.text.length || self.titleLabel.attributedText.length) {
            make.height.mas_equalTo(50);
        } else {
            make.height.mas_equalTo(0);
        }
    }];
    
    [self.dividerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.leading.equalTo(self.mas_leading).offset(BThemePaddingDefault);
        make.trailing.equalTo(self.mas_trailing).offset(-BThemePaddingDefault);
        if (self.titleLabel.text.length || self.titleLabel.attributedText.length) {
            make.height.mas_equalTo(0.5);
        } else {
            make.height.mas_equalTo(0);
        }
    }];
    
    CGFloat topPadding = (self.titleLabel.text.length || self.titleLabel.attributedText.length) ? 26 : 38;
    CGFloat bottomPadding = (self.titleLabel.text.length || self.titleLabel.attributedText.length) ? 26 : 35;
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dividerView.mas_bottom).offset(topPadding);
        make.leading.equalTo(self.dividerView.mas_leading);
        make.trailing.equalTo(self.dividerView.mas_trailing);
        make.bottom.equalTo(self.mas_bottom).offset(-bottomPadding);
    }];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title
          detail:(NSString *)detail
       topOffset:(CGFloat)topOffset
{
    self.titleLabel.text = nil; //title;
    self.detailLabel.text = detail;
    [self configureConstraintsWithTopOffset:topOffset];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
          attributedDetail:(NSAttributedString *)attributedDetail
                 topOffset:(CGFloat)topOffset
{
    self.titleLabel.attributedText = nil; //attributedTitle;
    self.detailLabel.attributedText = attributedDetail;
    [self configureConstraintsWithTopOffset:topOffset];
}

@end
