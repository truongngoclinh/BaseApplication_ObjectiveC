//
//  CPNotificationBanner.h
//  Cyberpay
//
//  A yellow banner at the top of page to hint/warn the user of some information
//  It has a bannerTitle at the left and a button at the right to indicate the action.
//  The entire view is clickable.
//
//  Created by Andrew Eng on 19/3/15.
//  Copyright (c) 2015 Garena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPNotificationBanner : UIButton

@property (strong, nonatomic) NSString *bannerTitle;
@property (strong, nonatomic) NSAttributedString *attributedBannerTitle;

@property (strong, nonatomic) NSString *buttonTitle;
/* Defaults to NO */
@property (assign, nonatomic) BOOL isButtonCircled;

- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle;

@end
