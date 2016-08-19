//
//  CommonFetch.m
//  课程助理
//
//  Created by Jason J on 13-5-28.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CommonFetch.h"

@implementation CommonFetch

+ (id)fetchData:(NSData *)data
{
    id result = nil;
    if (data) {
        NSError *error = nil;
        result = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                   error:&error];
    }
    return result;
}

@end
