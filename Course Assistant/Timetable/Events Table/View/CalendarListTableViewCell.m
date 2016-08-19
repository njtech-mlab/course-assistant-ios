//
//  CalendarListTableViewCell.m
//  南工课立方
//
//  Created by Jason J on 13-5-9.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarListTableViewCell.h"

@implementation CalendarListTableViewCell

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1];
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        self.backgroundView = view;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.alpha = 1.0;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1];
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        self.backgroundView = view;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.alpha = 1.0;
    }
}
*/

- (void)setup
{
    // Do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
