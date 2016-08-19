//
//  UserInfoFetcher.h
//  云知易课堂
//
//  Created by Jason J on 13-4-12.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STUDENT_NAME @"realname"
#define EMAIL @"email"
#define STUDENT_NUMBER @"schoolnumber"
#define SESSION_CODE @"sessioncode"
#define TEL @"tel"
#define GENDER @"sex"
#define NATURAL_CLASS @"natureclassname"
#define BIRTHDAY @"birthday"
#define FACULTY @"collegename"
#define DISTRICT @"campusname"
#define UNIVERSITY @"universityname"
#define MAJOR @"fieldname"
#define GRADE @"grade"
#define FIRST_DAY @"begindate"

#define TEACHER_NAME @"teachername"
#define PERSONNEL_NUMBER @"personnelnumber"
#define TEACHER_NUMBER @"teachernumber"

@interface UserInfoFetcher : NSObject

+ (NSDictionary *)fetchUserInfo:(NSData *)data;

@end
