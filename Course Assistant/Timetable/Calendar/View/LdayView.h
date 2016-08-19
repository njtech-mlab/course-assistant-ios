//
//  LdayView.h
//  南工课立方
//
//  Created by Jason J on 13-5-9.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LdayView : UIView

@property (strong, nonatomic) NSString *dayString;
@property (strong, nonatomic) NSString *weekString;
@property (nonatomic) BOOL isTodayString;
@property (nonatomic) BOOL isHighlighted;
@property (nonatomic) BOOL isTodayNotHighlighted;
@property (nonatomic) BOOL hadBeenSelected;
@property (nonatomic) BOOL todayBtnPressed;
@property (nonatomic) BOOL haveEvent;
@property (nonatomic) NSInteger numberOfEvents;

- (void)animateWeek;
- (void)clearView;
- (void)refreshView;

@end
