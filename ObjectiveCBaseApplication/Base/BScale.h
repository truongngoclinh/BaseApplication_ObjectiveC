//
//  BScale.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"

#define BX(x) [BScale scaleCGFloat:(x)]
#define BXSize(size) [BScale scaleCGSize:(size)]

#define BXMasImageWidth(x) make.width.mas_equalTo(BX((x).size.width))
#define BXMasImageHeight(x) make.height.mas_equalTo(BX((x).size.height))
#define BXMasImage(x) do { \
BXMasImageWidth(x); \
BXMasImageHeight(x); \
} while(0);

@interface BScale : NSObject

+ (CGFloat)scaleCGFloat:(CGFloat)x;
+ (CGSize)scaleCGSize:(CGSize)size;

@end
