//
//  User.h
//  课程助理
//
//  Created by Jason J on 2/11/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * faculty;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * grade;
@property (nonatomic) BOOL isTeacher;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * studentName;
@property (nonatomic, retain) NSString * naturalClass;
@property (nonatomic, retain) NSString * personnelNumber;
@property (nonatomic, retain) NSString * sessionCode;
@property (nonatomic, retain) NSString * studentNumber;
@property (nonatomic, retain) NSString * teacherNumber;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * university;
@property (nonatomic, retain) NSString * teacherName;

@end
