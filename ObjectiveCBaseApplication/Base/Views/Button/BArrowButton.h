//
//  CPArrowButton.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#import <UIKit/UIKit.h>

/**
    Button that looks like a tableViewCell. It has a title on the left and an arrow indicator at the right.
    Its title could be bold font.
 */
@interface BArrowButton : UIButton

/** Defaults to YES. */
@property (nonatomic, assign) BOOL shouldScale;

/** Optional */
@property (nonatomic, strong) UIImage *arrowImage;

- (void)setTitle:(NSString *)title bold:(BOOL)bold;

@end
