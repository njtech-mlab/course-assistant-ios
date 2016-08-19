//
//  CalendarViewController.m
//  Syllabus
//
//  Created by Jason J on 13-3-22.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CalendarViewController.h"
#import "CalendarCollectionCell.h"
#import "NJUTEventsCDTVC.h"
#import "dayView.h"

@interface CalendarViewController () <NJUTEventsCDTVCDelegate>
@property (weak, nonatomic) IBOutlet UILabel *calendarTVHeaderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *calendarTVHeaderWeekLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *noClassImageView;
@property (strong, nonatomic) CoreDataTableViewController *CDTVC;
@property (strong, nonatomic) NJUTEventsCDTVC *NJUTEventsTVC;
@property (nonatomic) BOOL notificationIsSchedule;
@end

@implementation CalendarViewController

// Lazy instantiation
- (NJUTEventsCDTVC *)calendarEventsTVC
{
    if (!_NJUTEventsTVC) {
        _NJUTEventsTVC = [[NJUTEventsCDTVC alloc] init];
    }
    return _NJUTEventsTVC;
}

- (CoreDataTableViewController *)CDTVC
{
    if (!_CDTVC) {
        _CDTVC = [[CoreDataTableViewController alloc] init];
    }
    return _CDTVC;
}

// How many cells in calendar collection view
- (NSInteger)daysCounting
{
    NSArray *monthDays = [self.calendarCalculator allMonthsDaysInThis:self.year];
    NSInteger blankDays = [self.calendarCalculator howManyDaysNotInThis:self.year this:self.month];
    
    return blankDays + [[monthDays objectAtIndex:self.month] integerValue];
}

// Update the year month label using current year and month
- (void)updateYearMonthLabelWithYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSString *yearAndMonth = [NSString stringWithFormat:@"%d 年 %d 月", year, month];
    [self.delegate calendarViewController:self didUpdateYearAndMonth:yearAndMonth];
    [self.delegate setYear:year];
    [self.delegate setMonth:month];
}

// Update and show day number in cell
// Send message to dayView.h
- (void)updateCell:(UICollectionViewCell *)cell usingString:(NSString *)string andIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CalendarCollectionCell class]]) {
        dayView *dayView = ((CalendarCollectionCell *)cell).dayView;
        dayView.dayString = string;
        dayView.isTodayString = self.calendarCalculator.isToday;
        dayView.isPreMonthDayString = self.calendarCalculator.isPreMonth;
        dayView.isNextMonthDayString = self.calendarCalculator.isNextMonth;
        dayView.haveEvent = NO;
        
        if (!self.calendarCalculator.isPreMonth) {
            NSInteger week = [self.calendarCalculator whichWeekByAGivenDay:[string integerValue] month:self.month year:self.year] - 1;
            if (week == -1) {
                week = 6;
            } else if (week == 0) {
                week = 7;
            }
            NSString *weekProperty;
            NSInteger numberOfWeekInTheSemester = [self.calendarCalculator whichWeekOfTheSemester:[NSString stringWithFormat:@"%d-%d-%d", self.year, self.month, [string integerValue]]];
            if (numberOfWeekInTheSemester % 2 == 1) {
                weekProperty = @"单";
            } else if (numberOfWeekInTheSemester % 2 == 0) {
                weekProperty = @"双";
            }
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timeToken" ascending:YES]];
            if ([weekProperty isEqualToString:@"单"]) {
                request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d && endWeek >= %d) && weekProperty IN { ' ', '单', '' }", week, numberOfWeekInTheSemester, numberOfWeekInTheSemester];
            } else if ([weekProperty isEqualToString:@"双"]) {
                request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d && endWeek >= %d) && weekProperty IN { ' ', '双', '' }", week, numberOfWeekInTheSemester, numberOfWeekInTheSemester];
            } else {
                request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d)", week, numberOfWeekInTheSemester];
            }
            self.CDTVC.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
            if ([self.CDTVC.fetchedResultsController.fetchedObjects count]) {
                dayView.haveEvent = YES;
            } else {
                dayView.haveEvent = NO;
            }
        }
        
        [dayView refreshView];
    }
}

- (void)highlightCell:(UICollectionViewCell *)cell
{
    if ([cell isKindOfClass:[CalendarCollectionCell class]]) {
        if (cell.selected) {
            [self clearHighlightOfCell:cell];
            //dayView *dayView = ((CalendarCollectionCell *)cell).dayView;
            //[dayView animateDay];
            //int randomNumber = (arc4random() % 3) + 1;
            UIImage *randomCircleImage = [UIImage imageNamed:@"calendar_day_overlay.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:randomCircleImage];
            imageView.frame = CGRectMake(4, -1, 35, 35);
            [cell addSubview:imageView];
        }
    }
}

- (void)clearHighlightOfCell:(UICollectionViewCell *)cell
{
    if ([cell isKindOfClass:[CalendarCollectionCell class]]) {
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
    }
}

// Update table view
// Requiring selected cell's indexPath
- (void)updateTableViewUsingIndexPath:(NSIndexPath *)indexPath
{
    // Get selected cell's day and week
    NSString *selectDayString = [self.calendarCalculator dayAtIndex:indexPath.item
                                                           withYear:self.year
                                                           andMonth:self.month];
    self.day = [selectDayString integerValue];
    NSInteger week = [self.calendarCalculator whichWeekByAGivenDay:self.day month:self.month year:self.year] - 1;
    if (week == -1) {
        week = 6;
    } else if (week == 0) {
        week = 7;
    }
    self.dayOfTheWeek = week;
    self.NJUTEventsTVC.dayOfTheWeek = self.dayOfTheWeek;
    [self updateNumberOfWeekInTheSemester];
    self.calendarTVHeaderDateLabel.text = [NSString stringWithFormat:@"%d/%d/%d", self.year, self.month, self.day];
    if (self.year == self.toyear && self.month == self.tomonth && self.day == self.today) {
        self.NJUTEventsTVC.isTodaySelected = YES;
    } else {
        self.NJUTEventsTVC.isTodaySelected = NO;
    }
    if (self.numberOfWeekInTheSemester > 0 && self.numberOfWeekInTheSemester < 21) {
        self.calendarTVHeaderWeekLabel.text = [NSString stringWithFormat:@"第%d周", self.numberOfWeekInTheSemester];
    } else {
        self.calendarTVHeaderWeekLabel.text = @"";
    }
    if (self.numberOfWeekInTheSemester % 2 == 1) {
        self.NJUTEventsTVC.weekProperty = @"单";
    } else if (self.numberOfWeekInTheSemester % 2 == 0) {
        self.NJUTEventsTVC.weekProperty = @"双";
    }
    self.NJUTEventsTVC.numberOfWeekInTheSemester = self.numberOfWeekInTheSemester;
    self.NJUTEventsTVC.managedObjectContext = self.managedObjectContext;
    if (self.NJUTEventsTVC.numberOfEvents == 0) {
        self.noClassImageView.hidden = NO;
        if (self.numberOfWeekInTheSemester <= 0 || self.numberOfWeekInTheSemester >= 21) {
            self.noClassImageView.image = [UIImage imageNamed:@"vacation_face.png"];
        } else {
            self.noClassImageView.image = [UIImage imageNamed:@"no_class_face.png"];
        }
    } else {
        self.noClassImageView.hidden = YES;
    }
    
    if (self.year > self.toyear) {
        self.NJUTEventsTVC.isFuture = YES;
    } else if (self.year == self.toyear && self.month > self.tomonth) {
        self.NJUTEventsTVC.isFuture = YES;
    } else if (self.year == self.toyear && self.month == self.tomonth && self.day > self.today) {
        self.NJUTEventsTVC.isFuture = YES;
    } else {
        self.NJUTEventsTVC.isFuture = NO;
    }
    
    if (self.year < self.toyear) {
        self.NJUTEventsTVC.isPast = YES;
    } else if (self.year == self.toyear && self.month < self.tomonth) {
        self.NJUTEventsTVC.isPast = YES;
    } else if (self.year == self.toyear && self.month == self.tomonth && self.day < self.today) {
        self.NJUTEventsTVC.isPast = YES;
    } else {
        self.NJUTEventsTVC.isPast = NO;
    }
}

- (void)displaySummaryViewWithCtid:(NSString *)ctid andStartTime:(NSString *)startTime;
{
    [self.delegate displaySummaryWithCtid:ctid andStartTime:startTime];
}

// Prepare for segue - Embed segue (calendar events table view)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Calendar Events"]) {
        if ([segue.destinationViewController isKindOfClass:[NJUTEventsCDTVC class]]) {
            self.NJUTEventsTVC = segue.destinationViewController;
            self.NJUTEventsTVC.delegate = self;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
}

@end
