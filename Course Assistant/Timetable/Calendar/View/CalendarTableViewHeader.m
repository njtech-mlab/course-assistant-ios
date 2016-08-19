//
//  CalendarTableViewHeader.m
//  Syllabus
//
//  Created by Jason J on 13-3-30.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CalendarTableViewHeader.h"

@interface CalendarTableViewHeader()

@end

@implementation CalendarTableViewHeader

/*
- (void)drawRect:(CGRect)rect
{
    [self.layer insertSublayer:[self headerGradient] atIndex:0];
    [self.layer insertSublayer:[self headerShadow] atIndex:1];
}

#define TABLE_VIEW_HEADER_HEIGHT 28

- (CAGradientLayer *)headerGradient
{
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    CGRect gradientFrame = CGRectMake(0, 0, self.frame.size.width, TABLE_VIEW_HEADER_HEIGHT);
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
    CGRect shadowFrame = CGRectMake(0, TABLE_VIEW_HEADER_HEIGHT, self.frame.size.width, 3);
    shadow.frame = shadowFrame;
    shadow.backgroundColor = [UIColor clearColor].CGColor;
    
    // This is gradient attribute
    shadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0.2 alpha:1].CGColor,
                                              (id)[UIColor clearColor].CGColor, nil];
    
    return shadow;
}*/

- (void)setup
{
    // Do initialization here
    UIImage *bg = [UIImage imageNamed:@"event-header-background-today.png"];
    self.backgroundColor = [UIColor colorWithPatternImage:bg];
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
