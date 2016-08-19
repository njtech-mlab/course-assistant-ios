//
//  CalendarDatePickerViewController.h
//  课程助理
//
//  Created by Jason J on 13-5-27.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarDatePickerViewController;

@protocol CalendarDatePickerViewControllerDelegate <NSObject>
- (void)cancelPick;
- (void)donePickWithYear:(NSInteger)year andMonth:(NSInteger)month;
@end

@interface CalendarDatePickerViewController : UIViewController

@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (weak, nonatomic) id <CalendarDatePickerViewControllerDelegate> delegate;

@end
