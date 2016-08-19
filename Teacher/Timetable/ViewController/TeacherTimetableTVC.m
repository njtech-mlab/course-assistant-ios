//
//  TeacherTimetableTVC.m
//  课程助理
//
//  Created by Jason J on 2/13/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "TeacherTimetableTVC.h"
#import "UIManagedDocumentHandler.h"
#import "StreamCDTVC.h"
#import "CalendarCalculator.h"
#import "CalendarDataFetcher.h"
#import "Course.h"
#import "User.h"

@interface TeacherTimetableTVC ()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id <UIManagedDocumentHandlerDelegate> managedDocumentHandlerDelegate;
@property (strong, nonatomic) CalendarCalculator *calendarCalculator;
@property (strong, nonatomic) NSDateComponents *comps;
@property (strong, nonatomic) NSString *ctid;
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *natureClass;
@property (nonatomic) NSInteger numberOfWeek;
@property (nonatomic) NSInteger todayWeek;
@end

@implementation TeacherTimetableTVC

@synthesize managedDocumentHandlerDelegate = _managedDocumentHandlerDelegate;

- (id <UIManagedDocumentHandlerDelegate>)managedDocumentHandlerDelegate
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if(!_managedDocumentHandlerDelegate && [appDelegate conformsToProtocol: @protocol(UIManagedDocumentHandlerDelegate)]) {
        return appDelegate;
    }
    return _managedDocumentHandlerDelegate;
}

- (CalendarCalculator *)calendarCalculator
{
    if (!_calendarCalculator) {
        _calendarCalculator = [[CalendarCalculator alloc] init];
    }
    return _calendarCalculator;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchedResultsController.fetchedObjects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    height = [[course.natureClass description] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + 92.0;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TeacherTimetableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    for (UILabel *label in [cell.contentView subviews]) {
        [label removeFromSuperview];
    }
    
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 240, 21)];
    courseNameLabel.backgroundColor = [UIColor clearColor];
    courseNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    courseNameLabel.text = course.name;
    
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 34, 240, 2008)];
    classLabel.backgroundColor = [UIColor clearColor];
    classLabel.font = [UIFont systemFontOfSize:14.0];
    classLabel.text = course.natureClass;
    classLabel.numberOfLines = 0;
    [classLabel sizeToFit];
    
    UILabel *classroomLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, cell.frame.size.height - 54, 150, 21)];
    classroomLabel.backgroundColor = [UIColor clearColor];
    classroomLabel.font = [UIFont systemFontOfSize:14.0];
    if (course.classroom) {
        classroomLabel.text = course.classroom;
    } else {
        classroomLabel.text = @"无";
    }
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, cell.frame.size.height - 28, 100, 21)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:14.0];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = [CalendarDataFetcher changeToStandardClassTime:[NSNumber numberWithInteger:course.timeToken]];
    
    UILabel *teachingAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, cell.frame.size.height - 28, 240, 21)];
    teachingAlertLabel.backgroundColor = [UIColor clearColor];
    teachingAlertLabel.font = [UIFont systemFontOfSize:14.0];
    if (self.numberOfWeek < course.startWeek) {
        teachingAlertLabel.text = @"这门课还没开始";
        teachingAlertLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    } else if (self.numberOfWeek > course.endWeek) {
        teachingAlertLabel.text = @"这门课已经结束";
        teachingAlertLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    } else if (self.numberOfWeek >= course.startWeek && self.numberOfWeek <= course.endWeek) {
        if ([course.weekProperty isEqualToString:@"单"]) {
            if (self.numberOfWeek % 2 == 0) {
                teachingAlertLabel.text = @"这门课为单周上课";
            } else {
                if (self.todayWeek == course.day) {
                    teachingAlertLabel.text = @"今天有课";
                    teachingAlertLabel.textColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1];
                } else if (self.todayWeek < course.day) {
                    if (course.day - self.todayWeek == 1) {
                        teachingAlertLabel.text = @"明天有课";
                        teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                    } else {
                        teachingAlertLabel.text = [NSString stringWithFormat:@"%d天后有课", course.day - self.todayWeek];
                        teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                    }
                } else {
                    teachingAlertLabel.text = @"本周已上完";
                    teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                }
            }
        } else if ([course.weekProperty isEqualToString:@"双"]) {
            if (self.numberOfWeek % 2 == 1) {
                teachingAlertLabel.text = @"这门课为双周上课";
            } else {
                if (self.todayWeek == course.day) {
                    teachingAlertLabel.text = @"今天有课";
                    teachingAlertLabel.textColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1];
                } else if (self.todayWeek < course.day) {
                    if (course.day - self.todayWeek == 1) {
                        teachingAlertLabel.text = @"明天有课";
                        teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                    } else {
                        teachingAlertLabel.text = [NSString stringWithFormat:@"%d天后有课", course.day - self.todayWeek];
                        teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                    }
                } else {
                    teachingAlertLabel.text = @"本周已上完";
                    teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                }
            }
        } else {
            if (self.todayWeek == course.day) {
                teachingAlertLabel.text = @"今天有课";
                teachingAlertLabel.textColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1];
            } else if (self.todayWeek < course.day) {
                if (course.day - self.todayWeek == 1) {
                    teachingAlertLabel.text = @"明天有课";
                    teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                } else {
                    teachingAlertLabel.text = [NSString stringWithFormat:@"%d天后有课", course.day - self.todayWeek];
                    teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                }
            } else {
                teachingAlertLabel.text = @"本周已上完";
                teachingAlertLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
            }
        }
    }
    
    [cell.contentView addSubview:courseNameLabel];
    [cell.contentView addSubview:classLabel];
    [cell.contentView addSubview:classroomLabel];
    [cell.contentView addSubview:timeLabel];
    [cell.contentView addSubview:teachingAlertLabel];
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.ctid = course.ctid;
    self.courseName = course.name;
    
    return indexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Teacher Stream"]) {
        if ([segue.destinationViewController isKindOfClass:[StreamCDTVC class]]) {
            StreamCDTVC *streamCDTVC = segue.destinationViewController;
            streamCDTVC.ctid = self.ctid;
            streamCDTVC.courseName = self.courseName;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!(self.managedDocumentHandlerDelegate.calendarDocument)) {
        [self.managedDocumentHandlerDelegate openCalendarDocument:^(BOOL finished) {
            if (finished) {
                self.managedObjectContext = self.managedDocumentHandlerDelegate.calendarDocument.managedObjectContext;
            }
        }];
    } else {
        if (!self.managedObjectContext) {
            self.managedObjectContext = self.managedDocumentHandlerDelegate.calendarDocument.managedObjectContext;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateComponents *comps = [CalendarCalculator getDateComps];
    self.comps = comps;
    NSInteger numberOfWeek = [self.calendarCalculator whichWeekOfTheSemester:[NSString stringWithFormat:@"%d-%d-%d", comps.year, comps.month, comps.day]];
    self.numberOfWeek = numberOfWeek;
    
    NSInteger week = [self.calendarCalculator whichWeekByAGivenDay:comps.day month:comps.month year:comps.year] - 1;
    if (week == -1) {
        week = 6;
    } else if (week == 0) {
        week = 7;
    }
    self.todayWeek = week;
    
    self.navigationItem.title = [NSString stringWithFormat:@"第 %d 周", self.numberOfWeek];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeFont : [UIFont systemFontOfSize:17.0] }];
    }
}

@end
