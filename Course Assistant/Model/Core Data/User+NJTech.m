//
//  User+NJTech.m
//  课程助理
//
//  Created by Jason J on 2/11/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "User+NJTech.h"
#import "UserInfoFetcher.h"

@implementation User (NJTech)

+ (User *)userWithInfo:(NSDictionary *)userInfoDictionary inManagedContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    // Should consider next version?
    // Unique user
    /*
     NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
     request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"studentID" ascending:YES]];
     request.predicate = [NSPredicate predicateWithFormat:@"studentID = %@", [userInfoDictionary[STUDENT_ID] description]];
     
     NSError *error;
     NSArray *match = [context executeFetchRequest:request error:&error];
     */
    
    user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
    user.studentName = [userInfoDictionary[STUDENT_NAME] description];
    user.email = [userInfoDictionary[EMAIL] description];
    user.studentNumber = [userInfoDictionary[STUDENT_NUMBER] description];
    user.sessionCode = [userInfoDictionary[SESSION_CODE] description];
    user.tel = [userInfoDictionary[TEL] description];
    user.gender = [userInfoDictionary[GENDER] description];
    user.naturalClass = [userInfoDictionary[NATURAL_CLASS] description];
    user.birthday = [userInfoDictionary[BIRTHDAY] description];
    user.faculty = [userInfoDictionary[FACULTY] description];
    user.district = [userInfoDictionary[DISTRICT] description];
    user.university = [userInfoDictionary[UNIVERSITY] description];
    user.major = [userInfoDictionary[MAJOR] description];
    user.grade = [userInfoDictionary[GRADE] description];
    
    user.teacherName = [userInfoDictionary[TEACHER_NAME] description];
    user.teacherNumber = [userInfoDictionary[TEACHER_NUMBER] description];
    user.personnelNumber = [userInfoDictionary[PERSONNEL_NUMBER] description];
    
    return user;
}

@end
