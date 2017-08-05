//
//  BSearchBar.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 4/1/16.
//  Copyright © 2016 smvn. All rights reserved.
//

#import "BSearchBar.h"

@implementation BSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        UIImage *image = [[UIImage imageNamed:@"element_titlebar_search_bg"]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(14, 5, 13, 4)];
        [self setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
        
        self.placeholder = TXT(@"label_search");
        self.tintColor = [UIColor whiteColor];
        
        // With the presense of customised leftButton, adjust the following:
        [self setBackgroundImage:[UIImage new]]; // Shown when a new VC is poped, at most bottom
        self.barTintColor = [UIColor whiteColor]; // Shown when a new VC is poped, above the backgroundImage
    }
    return self;
}

@end
