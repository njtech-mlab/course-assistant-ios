//
//  CalendarAppDelegate.h
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIManagedDocumentHandler.h"

@interface CalendarAppDelegate : UIResponder <UIApplicationDelegate, UIManagedDocumentHandlerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *content;

@end
