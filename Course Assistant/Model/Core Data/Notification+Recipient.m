//
//  Notification+Recipient.m
//  课程助理
//
//  Created by Jason J on 9/2/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import "Notification+Recipient.h"

@implementation Notification (Recipient)

+ (Notification *)notificationWithInfo:(NSDictionary *)notificationDictionary inManagedContext:(NSManagedObjectContext *)context
{
    Notification *notification = nil;
    
    notification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:context];
    notification.nid = [notificationDictionary objectForKey:@"id"];
    notification.title = [notificationDictionary objectForKey:@"title"];
    notification.content = [notificationDictionary objectForKey:@"content"];
    notification.type = [notificationDictionary objectForKey:@"type"];
    notification.date = [notificationDictionary objectForKey:@"date"];
    notification.sender = [notificationDictionary objectForKey:@"sender"];
    notification.isRead = [notificationDictionary objectForKey:@"isRead"];
    notification.isDelete = [notificationDictionary objectForKey:@"isDelete"];
    
    return notification;
}

@end
