//
//  NJUTEventsCDTVC.h
//  云知易课堂
//
//  Created by Jason J on 13-4-11.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarEventsCDTVC.h"

@class NJUTEventsCDTVC;

@protocol NJUTEventsCDTVCDelegate <NSObject>
@optional
- (void)displaySummaryViewWithCtid:(NSString *)ctid andStartTime:(NSString *)startTime;;
@end

@interface NJUTEventsCDTVC : CalendarEventsCDTVC

@property (weak, nonatomic) IBOutlet UITableView *calendarEventsView;
@property (nonatomic) BOOL isFuture;
@property (nonatomic) BOOL isPast;
@property (weak, nonatomic) id <NJUTEventsCDTVCDelegate> delegate;

@end
