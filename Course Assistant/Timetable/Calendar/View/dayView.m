//
//  dayView.m
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "dayView.h"

@implementation dayView

#define THIS_MONTH_DAY_FONT_COLOR 0.4
#define NOT_THIS_MONTH_DAY_FONT_COLOR 0.7
#define ROUNDED_RECT_CORNER_RADIUS 5.0
#define TODAY_BOUNDS_COLOR 0.95
#define HIGHLIGHTED_BOUNDS_COLOR 0.85

- (void)drawRect:(CGRect)rect
{
    /*
    UIColor *dayFontColor;
    if (self.isPreMonthDayString || self.isNextMonthDayString) {
        dayFontColor = [UIColor colorWithRed:NOT_THIS_MONTH_DAY_FONT_COLOR
                                       green:NOT_THIS_MONTH_DAY_FONT_COLOR
                                        blue:NOT_THIS_MONTH_DAY_FONT_COLOR
                                       alpha:1];
    } else if (self.isTodayString) {
        dayFontColor = [UIColor blackColor];
    } else {
        dayFontColor = [UIColor colorWithRed:THIS_MONTH_DAY_FONT_COLOR
                                       green:THIS_MONTH_DAY_FONT_COLOR
                                        blue:THIS_MONTH_DAY_FONT_COLOR
                                       alpha:1];
    }
    [self drawDay:dayFontColor];
    */
    UIColor *dayFontColor;
    if (self.isTodayString) {
        dayFontColor = [UIColor blackColor];
    } else {
        dayFontColor = [UIColor colorWithRed:THIS_MONTH_DAY_FONT_COLOR
                                       green:THIS_MONTH_DAY_FONT_COLOR
                                        blue:THIS_MONTH_DAY_FONT_COLOR
                                       alpha:1];
    }
    [self drawDay:dayFontColor];
}

#define ANIMATE_DURATION 0.3
#define BEGINNING_BOUNDS_CENTER_RATE 2.0

- (void)animateDay:(CGRect)textBounds
{
    if (!self.isTodayString) {
        if (!self.hadBeenSelected) {
            self.alpha = 0;
            self.center = CGPointMake(self.center.x, BEGINNING_BOUNDS_CENTER_RATE * self.center.y);
            [UIView animateWithDuration:ANIMATE_DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 1;
                self.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            } completion:nil];
        }
    }
}

#define DAY_FONT_SIZE 16

- (void)drawDay:(UIColor *)dayFontColor
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *dayFont = [UIFont systemFontOfSize:DAY_FONT_SIZE];
    if (self.isTodayString) {
        dayFontColor = [UIColor blackColor];
    }
    if (self.haveEvent) {
        dayFontColor = [UIColor colorWithRed:0/255.0 green:123.0/255.0 blue:243.0/255.0 alpha:1];
        //dayFont = [UIFont boldSystemFontOfSize:DAY_FONT_SIZE];
    }
    
    NSAttributedString *dayAttributedString = [[NSAttributedString alloc] initWithString:self.dayString
                                                                              attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : dayFont, NSForegroundColorAttributeName : dayFontColor }];
    
    CGRect textBounds;
    textBounds.size = [dayAttributedString size];
    textBounds.origin.x = (NSInteger)((self.bounds.size.width - textBounds.size.width) / 2);
    textBounds.origin.y = (NSInteger)((self.bounds.size.height- textBounds.size.height) / 2);
    for (UILabel *label in self.subviews) {
        [label removeFromSuperview];
    }
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:textBounds];
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.attributedText = dayAttributedString;
    [self addSubview:dayLabel];
    
    /*
    if (self.haveEvent) {
        UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 26, 4, 4) cornerRadius:2];
        [circle addClip];
        [[UIColor colorWithWhite:0.75 alpha:1] setFill];
        //[[UIColor colorWithRed:182.0/255.0 green:109.0/255.0 blue:119.0/255.0 alpha:1] setFill];
        [circle fill];
    } else {
        UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 26, 4, 4) cornerRadius:2];
        [circle addClip];
        [[UIColor whiteColor] setFill];
        [circle fill];
    }
    */
    //[dayAttributedString drawInRect:textBounds];
}

- (void)animateDay
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.transform = CGAffineTransformMakeScale(1.4, 1.4);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        view.transform = CGAffineTransformMakeScale(1, 1);
                    } completion:nil];
                }
            }];
        }
    }
}

- (void)clearView
{
    self.isHighlighted = NO;
}

- (void)refreshView
{
    [self setNeedsDisplay];
}

- (void)setup
{
    // Do initialization here
    self.hadBeenSelected = NO;
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
