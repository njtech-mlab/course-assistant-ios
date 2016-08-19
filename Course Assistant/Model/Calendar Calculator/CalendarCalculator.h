//
//  CalendarCalculator.h
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarCalculator : NSObject

@property (nonatomic) BOOL isToday;
@property (nonatomic) BOOL isPreMonth;
@property (nonatomic) BOOL isNextMonth;

+ (NSDateComponents *)getDateComps;
- (NSArray *)allMonthsDaysInThis:(NSInteger)year;
- (NSInteger)howManyDaysNotInThis:(NSInteger)year this:(NSInteger)month;
- (NSString *)dayAtIndex:(NSInteger)index withYear:(NSInteger)year andMonth:(NSInteger)month;
- (NSInteger)whichWeekByAGivenDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;
- (NSInteger)whichWeekOfTheSemester:(NSString *)todayDate;
- (NSArray *)dateWithIndex:(NSInteger)index today:(NSInteger)day toMonth:(NSInteger)month toYear:(NSInteger)year;
- (NSInteger)howManyDaysBetweenStartDay:(NSInteger)startDay
                                  Month:(NSInteger)startMonth
                                   Year:(NSInteger)startYear
                              andEndDay:(NSInteger)endDay
                                  Month:(NSInteger)endMonth
                                   Year:(NSInteger)endYear;

@end
