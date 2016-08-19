//
//  Like.h
//  课程助理
//
//  Created by Jason J on 10/6/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stream;

@interface Like : NSManagedObject

@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSNumber * tag;
@property (nonatomic, retain) NSNumber * toEdid;
@property (nonatomic, retain) Stream *streams;

@end
