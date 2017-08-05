//
//  BTButtonElement.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 17/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTLabelElement.h"
#import "BTElementCell.h"

@interface BTButtonElement : BTLabelElement

@property (nonatomic, assign) BOOL needCenterText;

@end

@interface BTButtonElementCell : BTElementCell

@property (nonatomic, assign) BOOL needCenterText;

@end
