//
//  dayView.h
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dayView : UIView

@property (strong, nonatomic) NSString *dayString;
@property (nonatomic) BOOL isPreMonthDayString;
@property (nonatomic) BOOL isNextMonthDayString;
@property (nonatomic) BOOL isTodayString;
@property (nonatomic) BOOL isHighlighted;
@property (nonatomic) BOOL isTodayNotHighlighted;
@property (nonatomic) BOOL hadBeenSelected;
@property (nonatomic) BOOL todayBtnPressed;
@property (nonatomic) BOOL haveEvent;
@property (nonatomic) NSInteger numberOfEvents;

- (void)animateDay;
- (void)clearView;
- (void)refreshView;

@end
