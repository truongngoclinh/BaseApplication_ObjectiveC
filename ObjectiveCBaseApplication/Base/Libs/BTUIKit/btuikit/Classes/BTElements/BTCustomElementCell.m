//
//  BTCustomElementCell.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 18/4/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTCustomElementCell.h"

@implementation BTCustomElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundColor = [UIColor clearColor];

        self.contentView.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void)setView:(UIView *)view
{
    // Only remove when superview is me!
    if (_view.superview == self.contentView) {
        [_view removeFromSuperview];
    }
    
    _view = view;

    [self.contentView addSubview:view];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.view.frame = CGRectMake(self.edgeInsets.left,
                                 self.edgeInsets.top,
                                 self.contentView.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right,
                                 self.contentView.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom);
}

@end
