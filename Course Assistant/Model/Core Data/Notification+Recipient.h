//
//  Notification+Recipient.h
//  课程助理
//
//  Created by Jason J on 9/2/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import "Notification.h"

@interface Notification (Recipient)

+ (Notification *)notificationWithInfo:(NSDictionary *)notificationDictionary inManagedContext:(NSManagedObjectContext *)context;

@end
