//
//  CalendarToolbar.m
//  Syllabus
//
//  Created by Jason J on 13-4-2.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarToolbar.h"

@interface CalendarToolbar() <UIBarPositioningDelegate, UIToolbarDelegate>

@end

@implementation CalendarToolbar

#define TOOLBAR_IMAGE_NAME @"toolbar.png"

/*
- (void)drawRect:(CGRect)rect
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_0) {
        UIImage *image = [UIImage imageNamed:@"toolbar_bg_ios6"];
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
}
*/

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)setup
{
    // Do initialization here
    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        [self setBackgroundImage:[UIImage imageNamed:@"toolbar_bg_ios6"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        self.barTintColor = [UIColor colorWithRed:139.0/255.0 green:149.0/255.0 blue:222.0/255.0 alpha:1];
        self.translucent = NO;
    }
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
