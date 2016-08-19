//
//  Stream+Evaluate.h
//  课程助理
//
//  Created by Jason J on 10/6/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import "Stream.h"

@interface Stream (Evaluate)

+ (Stream *)streamWithInfo:(NSDictionary *)streamDictionary inManagedContext:(NSManagedObjectContext *)context;

@end
