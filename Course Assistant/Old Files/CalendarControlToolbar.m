//
//  CalendarControlToolbar.m
//  南工课立方
//
//  Created by Jason J on 13-5-7.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CalendarControlToolbar.h"
#import "UIBarButtonItem+Custom.h"

@implementation CalendarControlToolbar

- (void)drawRect:(CGRect)rect
{
    [self.layer insertSublayer:[self headerShadow] atIndex:0];
    [self.layer insertSublayer:[self headerGradient] atIndex:1];
}

#define CONTROL_TOOLBAR_HEIGHT 44

- (CAGradientLayer *)headerGradient
{
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    CGRect gradientFrame = CGRectMake(0, 0, self.frame.size.width, CONTROL_TOOLBAR_HEIGHT);
    gradient.frame = gradientFrame;
    
    // This is gradient attribute
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHue:0
                                                               saturation:0
                                                               brightness:0.38
                                                                    alpha:1].CGColor,
                                                (id)[UIColor colorWithHue:0
                                                               saturation:0
                                                               brightness:0.26
                                                                    alpha:1].CGColor, nil];
    
    return gradient;
}

- (CAGradientLayer *)headerShadow
{
    CAGradientLayer *shadow = [[CAGradientLayer alloc] init];
    CGRect shadowFrame = CGRectMake(0, 40, self.frame.size.width, -45);
    
    shadow.frame = shadowFrame;
    shadow.backgroundColor = [UIColor clearColor].CGColor;

    // This is gradient attribute
    shadow.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,
                                              (id)[UIColor blackColor].CGColor, nil];
    
    return shadow;
}

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
