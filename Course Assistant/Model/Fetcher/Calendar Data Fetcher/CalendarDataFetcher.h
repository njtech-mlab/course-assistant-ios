//
//  CalendarDataFetcher.h
//  Syllabus
//
//  Created by Jason J on 13-3-27.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COURSE_ID @"ctid"
#define COURSE_NAME @"coursename"
#define TEACHER_NAME @"teachername"
#define CLASSROOM_LOCATION @"place"
#define DAY_OF_THE_WEEK @"day"
#define STARTING_WEEK @"beginweek"
#define ENDING_WEEK @"endweek"
#define LESSON_ID @"beginsection"
#define LESSON_DURATION @"endsection"
#define START_TIME @"starttime"
#define END_TIME @"endtime"
#define COURSE_BELONGING @"courseBelonging"
#define COURSE_PROPERTY @"courseNature"
#define EXAMINE_METHOD @"examMethod"
#define COURSE_CATEGORY @"courseCategory"
#define WEEK_PROPERTY @"oddoreven"
#define CREDIT @"credit"
#define COURSE_NUMBER @"choosenumber"

#define NATURE_CLASS @"natureclass"
#define SCHEDULE @"schedule"

@interface CalendarDataFetcher : NSObject

+ (NSString *)changeToStandardClassTime:(NSNumber *)classTimeToken;
+ (NSArray *)fetchCalendarData:(NSData *)data;

@end
