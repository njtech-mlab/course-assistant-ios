//
//  CalendarListViewController.h
//  南工课立方
//
//  Created by Jason J on 13-5-7.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "SyllabusViewController.h"

@class CalendarListViewController;

@protocol CalendarListViewControllerDelegate <NSObject>
- (void)calendarListViewController:(CalendarListViewController *)sender didUpdateYearAndMonth:(NSString *)yearMonth;
@optional
- (void)displaySummaryWithCtid:(NSString *)ctid andStartTime:(NSString *)startTime;
@end

@interface CalendarListViewController : SyllabusViewController

- (void)performToday;

@property (weak, nonatomic) id <CalendarListViewControllerDelegate> delegate;

@end
