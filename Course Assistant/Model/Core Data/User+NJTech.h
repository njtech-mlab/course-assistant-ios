//
//  User+NJTech.h
//  课程助理
//
//  Created by Jason J on 2/11/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "User.h"

@interface User (NJTech)

+ (User *)userWithInfo:(NSDictionary *)userInfoDictionary inManagedContext:(NSManagedObjectContext *)context;

@end
