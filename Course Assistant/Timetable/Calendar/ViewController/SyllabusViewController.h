//
//  CalendarViewController.h
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarCalculator.h"
#import "UIManagedDocumentHandler.h"

@interface SyllabusViewController : UIViewController

@property (strong, nonatomic) CalendarCalculator *calendarCalculator;
@property (nonatomic) NSInteger daysCounting;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger dayOfTheWeek;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger today;
@property (nonatomic) NSInteger toweekday;
@property (nonatomic) NSInteger toyear;
@property (nonatomic) NSInteger tomonth;
@property (nonatomic) NSInteger numberOfWeekInTheSemester;
@property (strong, nonatomic) NSIndexPath *selectIndexPath;
@property (strong, nonatomic) NSIndexPath *todayIndexPath;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id <UIManagedDocumentHandlerDelegate> managedDocumentHandlerDelegate;

- (void)updateYearMonthLabelWithYear:(NSInteger)year andMonth:(NSInteger)month;
- (void)updateCell:(UICollectionViewCell *)cell usingString:(NSString *)string andIndexPath:(NSIndexPath *)indexPath;
- (void)highlightCell:(UICollectionViewCell *)cell;
- (void)clearHighlightOfCell:(UICollectionViewCell *)cell;
- (void)updateTableViewUsingIndexPath:(NSIndexPath *)indexPath;
- (void)updateNumberOfWeekInTheSemester;
- (void)LreloadSelectedCell;

- (void)resetToday;
- (void)selectDateWithYear:(NSInteger)year andMonth:(NSInteger)month;
- (void)preMonthPressed;
- (void)nextMonthPressed;

@end
