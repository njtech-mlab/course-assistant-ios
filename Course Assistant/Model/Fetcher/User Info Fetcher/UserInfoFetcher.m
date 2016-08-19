//
//  UserInfoFetcher.m
//  云知易课堂
//
//  Created by Jason J on 13-4-12.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "UserInfoFetcher.h"

@implementation UserInfoFetcher

+ (NSDictionary *)fetchUserInfo:(NSData *)data
{
    NSDictionary *result = nil;
    if (data) {
        NSError *error = nil;
        result = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                   error:&error];
        if (result) {
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"realname"] forKey:@"studentName"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"tel"] forKey:@"tel"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"sex"] forKey:@"gender"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"natureclassname"] forKey:@"naturalClass"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"birthday"] forKey:@"birthday"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"collegename"] forKey:@"faculty"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"campusname"] forKey:@"district"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"universityname"] forKey:@"university"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"fieldname"] forKey:@"major"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"grade"] forKey:@"grade"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"schoolnumber"] forKey:@"studentID"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"email"] forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"begindate"] forKey:@"firstDay"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"teachername"] forKey:@"teacherName"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"personnelnumber"] forKey:@"personnelNumber"];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"teachernumber"] forKey:@"teacherNumber"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return result;
}

@end
