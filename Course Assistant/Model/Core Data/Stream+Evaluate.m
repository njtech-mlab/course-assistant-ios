//
//  Stream+Evaluate.m
//  课程助理
//
//  Created by Jason J on 10/6/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import "Stream+Evaluate.h"
#import "StreamFetcher.h"

@implementation Stream (Evaluate)

+ (Stream *)streamWithInfo:(NSDictionary *)streamDictionary inManagedContext:(NSManagedObjectContext *)context
{
    Stream *stream = nil;
    
    stream = [NSEntityDescription insertNewObjectForEntityForName:@"Stream" inManagedObjectContext:context];
    stream.edid = [[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_INFO_EDID];
    stream.ctid = [[[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_INFO_CTID] description];
    stream.date = [[[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_INFO_DATE] description];
    stream.evaluationAdvice = [[[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description];
    stream.evaluationAttendance = [[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_EVALUATION_INFO_ATTENDANCE];
    stream.evaluationDiscipline = [[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_EVALUATION_INFO_ARRANGEMENT];
    stream.evaluationEffect = [[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_EVALUATION_INFO_EFFECT];
    stream.evaluationSpeed = [[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_EVALUATION_INFO_SPEED];
    stream.numberOfLikes = [streamDictionary objectForKey:STREAM_LIKE_NUMBER];
    stream.sender = [[[streamDictionary objectForKey:STREAM_INFO] objectForKey:STREAM_INFO_SCHOOLNUMBER] description];
    
    return stream;
}

@end
