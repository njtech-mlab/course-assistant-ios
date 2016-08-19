//
//  NJUTListEventsCDTVC.h
//  南工课立方
//
//  Created by Jason J on 13-5-9.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarListEventsCDTVC.h"

@class NJUTListEventsCDTVC;

@protocol NJUTListEventsCDTVCDelegate <NSObject>
@optional
- (void)displaySummaryViewWithCtid:(NSString *)ctid andStartTime:(NSString *)startTime;
@end

@interface NJUTListEventsCDTVC : CalendarListEventsCDTVC

@property (weak, nonatomic) id <NJUTListEventsCDTVCDelegate> delegate;

@end
