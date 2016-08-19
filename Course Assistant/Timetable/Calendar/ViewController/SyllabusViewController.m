//
//  SyllabusViewController.m
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "SyllabusViewController.h"
#import "CalendarToolbar.h"
#import "CalendarControlToolbar.h"
#import "UIBarButtonItem+Custom.h"

@interface SyllabusViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) NSInteger selectedYear;
@property (nonatomic) NSInteger selectedMonth;
@property (nonatomic) NSInteger selectedDay;
@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionView;
@property (weak, nonatomic) UICollectionViewCell *todayCell;
//@property (strong, nonatomic) NSMutableArray *dayStringMutableArray;
//@property (strong, nonatomic) NSMutableArray *indexPathMutableArray;
@property (weak, nonatomic) UIImage *pagesBottomImage;
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation SyllabusViewController

@synthesize managedDocumentHandlerDelegate = _managedDocumentHandlerDelegate;

- (id <UIManagedDocumentHandlerDelegate>)managedDocumentHandlerDelegate
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if(!_managedDocumentHandlerDelegate && [appDelegate conformsToProtocol: @protocol(UIManagedDocumentHandlerDelegate)]) {
        return appDelegate;
    }
    return _managedDocumentHandlerDelegate;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        if (self.calendarCollectionView) {
            [self collectionView:self.calendarCollectionView didSelectItemAtIndexPath:self.selectIndexPath];
        }
    }
}

// Lazt instantiation
- (CalendarCalculator *)calendarCalculator
{
    if (!_calendarCalculator) {
        _calendarCalculator = [[CalendarCalculator alloc] init];
    }
    return _calendarCalculator;
}

/*
- (NSMutableArray *)dayStringMutableArray
{
    if (!_dayStringMutableArray) {
        _dayStringMutableArray = [[NSMutableArray alloc] init];
    }
    return _dayStringMutableArray;
}

- (NSMutableArray *)indexPathMutableArray
{
    if (!_indexPathMutableArray) {
        _indexPathMutableArray = [[NSMutableArray alloc] init];
    }
    return _indexPathMutableArray;
}
*/

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.daysCounting;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Current cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"day"
                                                                           forIndexPath:indexPath];
    [self clearHighlightOfCell:cell];
    
    // What dayString should draw in current cell
    NSString *dayString = [self.calendarCalculator dayAtIndex:indexPath.item
                                                     withYear:self.year
                                                     andMonth:self.month];
    
    // Add current cell's dayString and cell
    /*
    if ([self.dayStringMutableArray count] < self.daysCounting) {
        [self.dayStringMutableArray addObject:dayString];
        [self.indexPathMutableArray addObject:indexPath];
    } else {
        [self.dayStringMutableArray replaceObjectAtIndex:indexPath.item withObject:dayString];
        [self.indexPathMutableArray replaceObjectAtIndex:indexPath.item withObject:indexPath];
    }
    */
    
    // Draw day in current cell
    if (self.calendarCalculator.isPreMonth) {
        dayString = @"";
        cell.userInteractionEnabled = NO;
    } else {
        cell.userInteractionEnabled = YES;
    }
    [self updateCell:cell usingString:dayString andIndexPath:indexPath];
    
    // See if it is today
    // Save today's cell and indexPath
    if (self.year == self.toyear) {
        if (self.month == self.tomonth) {
            if (indexPath.item == self.daysCounting - 1) {
                [self collectionView:self.calendarCollectionView didSelectItemAtIndexPath:self.todayIndexPath];
            }
            if (!self.calendarCalculator.isPreMonth && !self.calendarCalculator.isNextMonth) {
                if ([dayString isEqualToString:[NSString stringWithFormat:@"%d", self.today]]) {
                    self.todayCell = cell;
                    self.todayIndexPath = indexPath;
                }
            }
        }
    }
    
    return cell;
}

// Abstract method
// Implement in subclass CalendarViewController
- (void)updateCell:(UICollectionViewCell *)cell usingString:(NSString *)string andIndexPath:(NSIndexPath *)indexPath
{
    // abstract
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndexPath = indexPath;
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    UICollectionViewCell *selectCell = [collectionView cellForItemAtIndexPath:indexPath];
    //NSString *selectCellDayString = [self.calendarCalculator dayAtIndex:indexPath.item
                                                               //withYear:self.year
                                                               //andMonth:self.month];
    if (selectCell.selected) {
        /*
        if (self.calendarCalculator.isPreMonth) {
            [self preMonthState];
            [self.calendarCollectionView performBatchUpdates:^{
                [self.calendarCollectionView reloadData];
            } completion:^(BOOL finished) {
                if (finished) {
                    [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
                    NSIndexPath *preMonthIndexPath = [self findCellIndexPathByDayString:selectCellDayString];
                    [self collectionView:self.calendarCollectionView didSelectItemAtIndexPath:preMonthIndexPath];
                }
            }];
        } else if (self.calendarCalculator.isNextMonth) {
            [self nextMonthState];
            [self.calendarCollectionView performBatchUpdates:^{
                [self.calendarCollectionView reloadData];
            } completion:^(BOOL finished) {
                if (finished) {
                    [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
                    NSIndexPath *nextMonthIndexPath = [self findCellIndexPathByDayString:selectCellDayString];
                    [self collectionView:self.calendarCollectionView didSelectItemAtIndexPath:nextMonthIndexPath];
                }
            }];
        } else {
            [self highlightCell:selectCell];
            [self updateTableViewUsingIndexPath:indexPath];
            self.selectedYear = self.year;
            self.selectedMonth = self.month;
            self.selectedDay = self.day;
        }
        */
        [self highlightCell:selectCell];
        [self updateTableViewUsingIndexPath:indexPath];
        self.selectedYear = self.year;
        self.selectedMonth = self.month;
        self.selectedDay = self.day;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    UICollectionViewCell *selectCell = [collectionView cellForItemAtIndexPath:indexPath];
    [self clearHighlightOfCell:selectCell];
}

// Abstract method
// Implement in subclass CalendarViewController
- (void)highlightCell:(UICollectionViewCell *)cell
{
    // abstract
}

- (void)clearHighlightOfCell:(UICollectionViewCell *)cell
{
    // abstract
}

- (void)updateTableViewUsingIndexPath:(NSIndexPath *)indexPath
{
    // abstract
}

/*
- (void)seeWhetherSelectedBefore
{
    if (self.year == self.selectedYear && self.month == self.selectedMonth) {
        NSIndexPath *indexPath = [self findCellIndexPathByDayString:[NSString stringWithFormat:@"%d", self.selectedDay]];
        [self collectionView:self.calendarCollectionView didSelectItemAtIndexPath:indexPath];
    }
}

// Find cell's index path by given dayString
- (NSIndexPath *)findCellIndexPathByDayString:(NSString *)dayString
{
    NSDictionary *indexPathDayStringDic = [[NSDictionary alloc] initWithObjects:[self.dayStringMutableArray copy]
                                                                        forKeys:[self.indexPathMutableArray copy]];
    NSIndexPath *indexPath;
    NSArray *indexPathArray = [indexPathDayStringDic allKeysForObject:dayString];
    if ([indexPathArray count] == 1) {
        indexPath = [indexPathArray lastObject];
    } else {
        if ([dayString intValue] < 14) {
            indexPath = [indexPathArray objectAtIndex:0];
        } else {
            indexPath = [indexPathArray lastObject];
        }
    }
    return indexPath;
}
*/

// Update the year month label using current year and month
- (void)updateYearMonthLabelWithYear:(NSInteger)year andMonth:(NSInteger)month
{
    // abstract
}

// Update the number of week in the semester
- (void)updateNumberOfWeekInTheSemester
{
    self.numberOfWeekInTheSemester = [self.calendarCalculator whichWeekOfTheSemester:[NSString stringWithFormat:@"%d-%d-%d", self.year, self.month, self.day]];
}

- (void)preMonthState
{
    self.month--;
    if (self.month < 1) {
        self.year--;
        self.month = 12;
    }
    self.calendarCalculator.isToday = NO;
    self.calendarCalculator.isPreMonth = NO;
    self.calendarCalculator.isNextMonth = NO;
}

- (void)nextMonthState
{
    self.month++;
    if (self.month > 12) {
        self.year++;
        self.month = 1;
    }
    self.calendarCalculator.isToday = NO;
    self.calendarCalculator.isPreMonth = NO;
    self.calendarCalculator.isNextMonth = NO;
}

// Turn to pre month
- (void)preMonthPressed
{
    [self preMonthState];
    /*
    [self.calendarCollectionView performBatchUpdates:^{
        [self.calendarCollectionView reloadData];
    } completion:^(BOOL finished) {
        if (finished) {
            [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
            //[self seeWhetherSelectedBefore];
        }
    }];
    */
    [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
    [self.calendarCollectionView reloadData];
}

// Turn to next month
- (void)nextMonthPressed
{
    [self nextMonthState];
    /*
    [self.calendarCollectionView performBatchUpdates:^{
        [self.calendarCollectionView reloadData];
    } completion:^(BOOL finished) {
        if (finished) {
            [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
            //[self seeWhetherSelectedBefore];
        }
    }];
    */
    [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
    [self.calendarCollectionView reloadData];
}

- (void)selectDateWithYear:(NSInteger)year andMonth:(NSInteger)month
{
    if (year == 0) {
        year = self.year;
    }
    if (month == 0) {
        month = self.month;
    }
    self.year = year;
    self.month = month;
    self.calendarCalculator.isToday = NO;
    self.calendarCalculator.isPreMonth = NO;
    self.calendarCalculator.isNextMonth = NO;
    /*
    [self.calendarCollectionView performBatchUpdates:^{
        [self.calendarCollectionView reloadData];
    } completion:^(BOOL finished) {
        if (finished) {
            [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
            //[self seeWhetherSelectedBefore];
        }
    }];
    */
    [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
    [self.calendarCollectionView reloadData];
}

- (void)resetToday
{
    NSDateComponents *comps = [CalendarCalculator getDateComps];
    self.toyear = comps.year;
    self.tomonth = comps.month;
    self.today = comps.day;
    if (!(self.year == self.toyear && self.month == self.tomonth && self.day == self.today)) {
        self.year = self.toyear;
        self.month = self.tomonth;
        self.day = self.today;
        self.calendarCalculator.isToday = YES;
        self.calendarCalculator.isPreMonth = NO;
        self.calendarCalculator.isNextMonth = NO;
        [self updateYearMonthLabelWithYear:self.year andMonth:self.month];
        [self.calendarCollectionView reloadData];
    }
}

- (void)LreloadSelectedCell
{
    // abstract
}

- (void)documentIsReady:(NSTimer *)timer
{
    NSArray *cellArray = [self.calendarCollectionView visibleCells];
    BOOL someCellSelected = NO;
    for (UICollectionViewCell *cell in cellArray) {
        if (!cell.selected) {
            continue;
        } else if (cell.selected) {
            someCellSelected = YES;
            break;
        }
    }
    if (!someCellSelected) {
        [self collectionView:self.calendarCollectionView didSelectItemAtIndexPath:self.todayIndexPath];
    }
}

#define TIMER_INTERVAL 0.1

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                  target:self
                                                selector:@selector(documentIsReady:)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)stopBackgroundTimer
{
    [self.timer invalidate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopBackgroundTimer];
}

#define NAVIGATION_VIEW_CONTROLLER_IDENTIFIER @"Navigation"
#define COLLECTION_VIEW_BG_IMAGE_NAME @"collection_view_bg@2x.png"

// Initialize sliding menu when view will appear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if (!(self.managedDocumentHandlerDelegate.calendarDocument)) {
        [self.managedDocumentHandlerDelegate openCalendarDocument:^(BOOL finished) {
            if (finished) {
                self.managedObjectContext = self.managedDocumentHandlerDelegate.calendarDocument.managedObjectContext;
                [self documentIsReady:self.timer];
            }
        }];
    } else {
        if (!self.managedObjectContext) {
            self.managedObjectContext = self.managedDocumentHandlerDelegate.calendarDocument.managedObjectContext;
            [self startTimer];
        }
    }
    
    // Set CalendarCollectionView's background
    //UIImage *img = [UIImage imageNamed:COLLECTION_VIEW_BG_IMAGE_NAME];
    //UIColor *collectionViewBg = [[UIColor alloc] initWithPatternImage:img];
    //self.calendarCollectionView.backgroundColor = collectionViewBg;
}

// View did load
// All outlets are set
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Set CalendarCollectionView's data source to self
    self.calendarCollectionView.dataSource = self;
    
    // Set CalendarCollectionView's delegate to self
    self.calendarCollectionView.delegate = self;
        
    // Initialize date components and date label
    NSDateComponents *comps = [CalendarCalculator getDateComps];
    self.year = comps.year;
    self.month = comps.month;
    self.day = comps.day;
    self.toyear = comps.year;
    self.tomonth = comps.month;
    self.today = comps.day;
    self.toweekday = comps.weekday;
    
    // Initialize number of week in the semester
    [self updateNumberOfWeekInTheSemester];
}

@end
