//
//  Notification.h
//  课程助理
//
//  Created by Jason J on 10/6/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isDelete;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * nid;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;

@end
