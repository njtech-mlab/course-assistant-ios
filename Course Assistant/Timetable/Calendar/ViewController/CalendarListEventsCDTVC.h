//
//  CalendarListEventsCDTVC.h
//  南工课立方
//
//  Created by Jason J on 13-5-9.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CalendarListEventsCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL isTodaySelected;
@property (nonatomic) BOOL isTomorrowSelected;
@property (nonatomic) NSInteger todayOfTheWeek;
@property (nonatomic) NSInteger tomorrowOfTheWeek;
@property (nonatomic) NSInteger theDayAfterTomorrowOfTheWeek;
@property (nonatomic) NSInteger numberOfWeekInTheSemester;
@property (strong, nonatomic) NSString *weekProperty;
@property (nonatomic) NSInteger numberOfEvents;
@property (strong, nonatomic) NSString *tomorrowDateString;
@property (strong, nonatomic) NSString *theDayAfterTomorrowDateString;
@property (strong, nonatomic) NSString *ctid;
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseProperty;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *teacherName;
@property (nonatomic) BOOL isFuture;
@property (nonatomic) BOOL isPast;

@end
