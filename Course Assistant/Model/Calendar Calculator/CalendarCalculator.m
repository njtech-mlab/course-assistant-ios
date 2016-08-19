//
//  CalendarCalculator.m
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarCalculator.h"

@implementation CalendarCalculator

+ (NSDateComponents *)getDateComps
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit;
    NSDate *date = [NSDate date];
    comps = [gregorian components:unitFlags fromDate:date];
    
    return comps;
}

- (BOOL)isLeapYear:(NSInteger)year
{
    if ((0 == year % 4 && 0 != year % 100) || 0 == year % 400) return YES;
    else return NO;
}

- (NSArray *)allMonthsDaysInThis:(NSInteger)year
{
    NSMutableArray *allMonthsDays = [[NSMutableArray alloc] init];
    
    NSArray *standardMonthsDays;
    standardMonthsDays = @[@"0", @"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    [allMonthsDays addObjectsFromArray:standardMonthsDays];
    if ([self isLeapYear:year])
    {
        [allMonthsDays replaceObjectAtIndex:2 withObject:@"29"];
    }
    
    return [allMonthsDays copy];
}

- (NSInteger)howManyDaysNotInThis:(NSInteger)year this:(NSInteger)month
{
    NSInteger daysNotInThisMonth;
    
    NSInteger totalDay=0, i, temp;
    for (i = 1; i < month; i++)
    {
        totalDay += [[[self allMonthsDaysInThis:year] objectAtIndex:i] intValue];
    }
    totalDay += 1;
    temp = year - 1 + (NSInteger)((year - 1) / 4) - (NSInteger)(( year - 1) / 100) + (NSInteger)((year - 1) / 400) + totalDay;
    daysNotInThisMonth = temp % 7;
    
    return daysNotInThisMonth;
}

- (NSString *)dayAtIndex:(NSInteger)index withYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSString *day;
    
    NSDateComponents *comps = [CalendarCalculator getDateComps];
    NSInteger today = comps.day;
    NSInteger thisMonth = comps.month;
    NSInteger thisYear = comps.year;
    NSInteger currentPreMonth = month - 1;
    if (currentPreMonth < 1) {
        currentPreMonth = 12;
    }
    NSInteger howManyDaysInPreMonth = [[[self allMonthsDaysInThis:year] objectAtIndex:currentPreMonth] intValue];
    NSInteger howManyDaysInThisMonth = [[[self allMonthsDaysInThis:year] objectAtIndex:month] intValue];
    NSInteger blankDay = [self howManyDaysNotInThis:year this:month];
    if (index < blankDay) {
        day = [NSString stringWithFormat:@"%d", howManyDaysInPreMonth - blankDay + index + 1];
        self.isPreMonth = YES;
        self.isToday = NO;
        self.isNextMonth = NO;
    } else if (index >= blankDay && index < (howManyDaysInThisMonth + blankDay)) {
        day = [NSString stringWithFormat:@"%d", (index - blankDay + 1)];
        if (year == thisYear && month == thisMonth) {
            if (index == today + blankDay - 1) {
                self.isToday = YES;
            } else {
                self.isToday = NO;
            }
        } else {
            self.isToday = NO;
        }
        self.isPreMonth = NO;
        self.isNextMonth = NO;
    } else {
        day = [NSString stringWithFormat:@"%d", index - howManyDaysInThisMonth - blankDay + 1];
        self.isNextMonth = YES;
        self.isToday = NO;
        self.isPreMonth = NO;
    }
    
    return day;
}

#define CENTURY 20

- (NSInteger)whichWeekByAGivenDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year
{
    NSInteger week = 0;
    if (month == 1) {
        month = 13;
        year = year - 1;
    } else if (month == 2) {
        month = 14;
        year = year - 1;
    }
    week = year + (year / 4) + (CENTURY / 4) - (2 * CENTURY) + (26 * (month + 1) / 10) + day - 1;
    week = week % 7;
    return week;
}

- (NSInteger)whichWeekOfTheSemester:(NSString *)todayDate
{
    NSInteger week = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSString *firstDay = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstDay"];
    NSString *firstDay = @"2014-02-24";
    NSDate *startDate = [formatter dateFromString:firstDay];
    NSDate *endDate = [formatter dateFromString:todayDate];
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
    NSInteger days = [comps day];
    if (days >= 0) {
        week = (days - days % 7) / 7 + 1;
    }
    
    return week;
}

- (NSArray *)dateWithIndex:(NSInteger)index today:(NSInteger)day toMonth:(NSInteger)month toYear:(NSInteger)year
{
    NSArray *LdateArray = [[NSArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", year, month, day]];
    // dateByAddingTimeInterval 有上限，大概不到24*60*60*25000
    NSDate *date = [startDate dateByAddingTimeInterval:24 * 60 * 60 * index];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSString *Lday = [NSString stringWithFormat:@"%d", comps.day];
    NSString *Lmonth = [NSString stringWithFormat:@"%d", comps.month];
    NSString *Lyear = [NSString stringWithFormat:@"%d", comps.year];
    NSInteger originalLWeek = [self whichWeekByAGivenDay:[Lday integerValue]
                                                   month:[Lmonth integerValue]
                                                    year:[Lyear integerValue]];
    NSString *Lweek = [NSString stringWithFormat:@"%d", originalLWeek - 1];
    LdateArray = [NSArray arrayWithObjects:Lday, Lweek, Lmonth, Lyear, nil];
    
    return LdateArray;
}

- (NSInteger)howManyDaysBetweenStartDay:(NSInteger)startDay
                                  Month:(NSInteger)startMonth
                                   Year:(NSInteger)startYear
                              andEndDay:(NSInteger)endDay
                                  Month:(NSInteger)endMonth
                                   Year:(NSInteger)endYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", startYear, startMonth, startDay]];
    NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", endYear, endMonth, endDay]];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    NSInteger days = [comps day];
    
    return days;
}

@end
