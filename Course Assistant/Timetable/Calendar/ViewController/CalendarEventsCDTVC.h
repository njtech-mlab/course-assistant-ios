//
//  CalendarEventsCDTVC.h
//  云知易课堂
//
//  Created by Jason J on 13-4-11.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CalendarEventsCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL isTodaySelected;
@property (nonatomic) NSInteger dayOfTheWeek;
@property (nonatomic) NSInteger numberOfWeekInTheSemester;
@property (strong, nonatomic) NSString *weekProperty;
@property (nonatomic) NSInteger numberOfEvents;
@property (strong, nonatomic) NSString *ctid;
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseProperty;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *teacherName;

@end
