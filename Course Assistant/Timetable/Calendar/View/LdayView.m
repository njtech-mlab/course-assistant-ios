//
//  LdayView.m
//  南工课立方
//
//  Created by Jason J on 13-5-9.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LdayView.h"

@implementation LdayView

#define THIS_MONTH_DAY_FONT_COLOR 0.4
#define NOT_THIS_MONTH_DAY_FONT_COLOR 0.6
#define ROUNDED_RECT_CORNER_RADIUS 5.0
#define TODAY_BOUNDS_COLOR 0.95
#define HIGHLIGHTED_BOUNDS_COLOR 0.85

- (void)drawRect:(CGRect)rect
{
    UIColor *dayFontColor;
    //UIColor *weekFontColor;
    
    dayFontColor = [UIColor colorWithRed:THIS_MONTH_DAY_FONT_COLOR
                                   green:THIS_MONTH_DAY_FONT_COLOR
                                    blue:THIS_MONTH_DAY_FONT_COLOR alpha:1];
    //weekFontColor = [UIColor colorWithRed:NOT_THIS_MONTH_DAY_FONT_COLOR
                                    //green:NOT_THIS_MONTH_DAY_FONT_COLOR
                                     //blue:NOT_THIS_MONTH_DAY_FONT_COLOR alpha:1];
    [self drawDay:dayFontColor];
    //[self drawWeek:weekFontColor];
}

#define DAY_FONT_SIZE 22

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
    CGRect dayBounds;
    dayBounds.size = [dayAttributedString size];
    dayBounds.origin.x = (NSInteger)((self.bounds.size.width - dayBounds.size.width) / 2) + 1;
    dayBounds.origin.y = self.bounds.size.height - dayBounds.size.height - 10;
    [dayAttributedString drawInRect:dayBounds];
}

#define WEEK_FONT_SIZE 10

- (void)drawWeek:(UIColor *)dayFontColor
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *dayFont = [UIFont systemFontOfSize:WEEK_FONT_SIZE];
    
    NSString *weekString = [[LdayView standarWeekDescription] objectForKey:self.weekString];
    if (self.isTodayString) {
        dayFont = [UIFont boldSystemFontOfSize:WEEK_FONT_SIZE];
    }
    
    NSAttributedString *weekAttributedString = [[NSAttributedString alloc] initWithString:weekString
                                                                               attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : dayFont, NSForegroundColorAttributeName : dayFontColor }];
    CGRect weekBounds;
    weekBounds.size = [weekAttributedString size];
    weekBounds.origin.x = (NSInteger)((self.bounds.size.width - weekBounds.size.width) / 2) + 1;
    weekBounds.origin.y = 8;
    //[weekAttributedString drawInRect:weekBounds];
    for (UILabel *label in self.subviews) {
        [label removeFromSuperview];
    }
    UILabel *weekLabel = [[UILabel alloc] initWithFrame:weekBounds];
    weekLabel.backgroundColor = [UIColor clearColor];
    weekLabel.attributedText = weekAttributedString;
    [self addSubview:weekLabel];
}

- (void)animateWeek
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

+ (NSDictionary *)standarWeekDescription
{
    return @{ @"1" : @"星期一",
              @"2" : @"星期二",
              @"3" : @"星期三",
              @"4" : @"星期四",
              @"5" : @"星期五",
              @"6" : @"星期六",
              @"7" : @"星期日" };
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
