//
//  BTSectionElement.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 28/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTElement.h"

static CGFloat BTSectionElementBottomPaddingNotSet = -1;

@interface BTSectionElement : BTElement

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, strong) NSString *footerText;
@property (nonatomic, strong) NSString *headerText;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) CGFloat bottomPadding;

- (NSInteger)numberOfRows;

- (BTElement *)elementForKey:(NSString *)key;

- (CGFloat)heightForHeader;
- (CGFloat)heightForFooter;

@end
