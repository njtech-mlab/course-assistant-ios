//
//  CalendarDataFetcher.m
//  Syllabus
//
//  Created by Jason J on 13-3-27.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarDataFetcher.h"

@implementation CalendarDataFetcher

+ (NSArray *)fetchCalendarData:(NSData *)data
{
    NSArray *result = nil;
    if (data) {
        NSError *error = nil;
        result = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                   error:&error];
    }
    return result;
}

+ (NSDictionary *)standardClassTime
{
    return @{ @"1" : @"8:10 - 9:50",
              @"3" : @"10:20 - 12:00",
              @"5" : @"13:30 - 15:10",
              @"7" : @"15:40 - 17:20",
              @"9" : @"18:00 - 20:00" };
}

+ (NSString *)changeToStandardClassTime:(NSNumber *)classTimeToken
{
    return [[CalendarDataFetcher standardClassTime] objectForKey:[NSString stringWithFormat:@"%@", classTimeToken]];
}

@end
