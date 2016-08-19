//
//  CalendarViewController.h
//  Syllabus
//
//  Created by Jason J on 13-3-22.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "SyllabusViewController.h"

@class CalendarViewController;

@protocol CalendarViewControllerDelegate <NSObject>
- (void)calendarViewController:(CalendarViewController *)sender didUpdateYearAndMonth:(NSString *)yearMonth;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@optional
- (void)displaySummaryWithCtid:(NSString *)ctid andStartTime:(NSString *)startTime;;
@end

@interface CalendarViewController : SyllabusViewController

@property (weak, nonatomic) id <CalendarViewControllerDelegate> delegate;

@end
