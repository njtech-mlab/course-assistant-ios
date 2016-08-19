//
//  UIManagedDocumentHandler.h
//  课程助理
//
//  Created by Jason J on 13-5-24.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIManagedDocumentHandler;

@protocol UIManagedDocumentHandlerDelegate <NSObject>
@required
@property (strong, nonatomic) UIManagedDocument *calendarDocument;
@property (strong, nonatomic) UIManagedDocument *notificationDocument;
- (void)openCalendarDocument:(void (^)(BOOL finished))completion;
- (void)openNotificationDocument:(void (^)(BOOL finished))completion;
@end

@interface UIManagedDocumentHandler : NSObject

@end
