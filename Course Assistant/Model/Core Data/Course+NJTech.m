//
//  Course+NJTech.m
//  课程助理
//
//  Created by Jason J on 2/11/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "Course+NJTech.h"
#import "CalendarDataFetcher.h"

@implementation Course (NJTech)

+ (Course *)courseWithInfo:(NSDictionary *)infoDictionary inManagedContext:(NSManagedObjectContext *)context
{
    Course *course = nil;
    
    course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
    
    course.ctid = [infoDictionary[COURSE_ID] description];
    course.name = [infoDictionary[COURSE_NAME] description];
    course.courseBelonging = [infoDictionary[COURSE_BELONGING] description];
    course.courseProperty = [infoDictionary[COURSE_PROPERTY] description];
    course.examineMethod = [infoDictionary[EXAMINE_METHOD] description];
    course.courseCategory = [infoDictionary[COURSE_CATEGORY] description];
    course.credit = [infoDictionary[CREDIT] description];
    course.courseNumber = [infoDictionary[COURSE_NUMBER] description];
    course.teacherName = [infoDictionary[TEACHER_NAME] description];
    course.natureClass = [infoDictionary[NATURE_CLASS] description];
    course.weekProperty = [infoDictionary[WEEK_PROPERTY] description];
    course.time = [NSString stringWithFormat:@"%@ - %@", [infoDictionary[START_TIME] description], [infoDictionary[END_TIME] description]];
    course.classroom = [infoDictionary[CLASSROOM_LOCATION] description];
    course.startTime = [infoDictionary[START_TIME] description];
    course.endTime = [infoDictionary[END_TIME] description];
    course.startWeek = [infoDictionary[STARTING_WEEK] intValue];
    course.timeToken = [infoDictionary[LESSON_ID] intValue];
    course.duration = [infoDictionary[ENDING_WEEK] intValue] - [infoDictionary[STARTING_WEEK] intValue];
    course.day = [infoDictionary[DAY_OF_THE_WEEK] intValue];
    course.endWeek = [infoDictionary[ENDING_WEEK] intValue];
    
    return course;
}

@end
