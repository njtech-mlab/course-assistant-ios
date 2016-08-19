//
//  Course.h
//  课程助理
//
//  Created by Jason J on 2/11/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * classroom;
@property (nonatomic, retain) NSString * courseBelonging;
@property (nonatomic, retain) NSString * courseCategory;
@property (nonatomic, retain) NSString * courseNumber;
@property (nonatomic, retain) NSString * courseProperty;
@property (nonatomic, retain) NSString * credit;
@property (nonatomic, retain) NSString * ctid;
@property (nonatomic) int16_t day;
@property (nonatomic) int16_t duration;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic) int16_t endWeek;
@property (nonatomic, retain) NSString * examineMethod;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic) int16_t startWeek;
@property (nonatomic, retain) NSString * time;
@property (nonatomic) int16_t timeToken;
@property (nonatomic, retain) NSString * weekProperty;
@property (nonatomic, retain) NSString * natureClass;
@property (nonatomic, retain) NSString * teacherName;

@end
