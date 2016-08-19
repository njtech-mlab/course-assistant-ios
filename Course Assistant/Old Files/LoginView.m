//
//  LoginView.m
//  南工云课堂
//
//  Created by Jason J on 13-4-18.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginView.h"

@implementation LoginView

#define ROUNDED_RECT_CORNER_RADIUS 10.0f

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:ROUNDED_RECT_CORNER_RADIUS];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [self.layer insertSublayer:[self viewGradient] atIndex:0];
    [self.layer setCornerRadius:ROUNDED_RECT_CORNER_RADIUS];
}

#define LOGIN_VIEW_HEADER_HEIGHT 346.0

- (CAGradientLayer *)viewGradient
{
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    CGRect gradientFrame = CGRectMake(0, 0, self.frame.size.width, LOGIN_VIEW_HEADER_HEIGHT);
    gradient.frame = gradientFrame;
    
    // This is gradient attribute
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
                                                (id)[UIColor colorWithHue:0
                                                               saturation:0
                                                               brightness:0.82
                                                                    alpha:1].CGColor, nil];
    
    return gradient;
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
