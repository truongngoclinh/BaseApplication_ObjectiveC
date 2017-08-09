//
//  BLoginTextField.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/9/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BLoginTextField.h"

@implementation BLoginTextField

- (instancetype)init {
    self = [super initWithStyle:BTextFieldStyleInputNew];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.font = [BTheme lightFontOfSize:BX(16)];
        self.textColor = [BTheme textColor];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentInset = UIEdgeInsetsMake(0, BX(12), 0, BX(12));
        self.placeholderAttributes = @{ NSFontAttributeName: [BTheme lightFontOfSize:BX(16)],
                                        NSForegroundColorAttributeName : [BTheme textColorLightest] };
    }
    
    return self;
}

@end
