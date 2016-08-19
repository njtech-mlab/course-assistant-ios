//
//  Course+NJTech.h
//  课程助理
//
//  Created by Jason J on 2/11/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "Course.h"

@interface Course (NJTech)

+ (Course *)courseWithInfo:(NSDictionary *)infoDictionary inManagedContext:(NSManagedObjectContext *)context;

@end
