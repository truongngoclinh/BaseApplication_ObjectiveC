//
//  BAlertInfoView.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

/** 
    Note: title has been disabled in the new design
 */
@interface BAlertInfoView : UIView

+ (UIFont *)titleFont;
+ (UIFont *)detailFont;

+ (BAlertInfoView *)alertInfoViewWithTitle:(NSString *)title
                                     detail:(NSString *)detail;

+ (BAlertInfoView *)alertInfoViewWithTitle:(NSString *)title
                                     detail:(NSString *)detail
                                  topOffset:(CGFloat)topOffset;

+ (BAlertInfoView *)alertInfoViewWithAttributedTitle:(NSAttributedString *)attributedTitle
                                     attributedDetail:(NSAttributedString *)attributedDetail;

+ (BAlertInfoView *)alertInfoViewWithAttributedTitle:(NSAttributedString *)attributedTitle
                                     attributedDetail:(NSAttributedString *)attributedDetail
                                            topOffset:(CGFloat)topOffset;

@end
