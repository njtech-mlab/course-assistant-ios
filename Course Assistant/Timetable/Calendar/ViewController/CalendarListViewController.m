//
//  CalendarListViewController.m
//  南工课立方
//
//  Created by Jason J on 13-5-7.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarListViewController.h"
#import "CalendarListCollectionCell.h"
#import "NJUTListEventsCDTVC.h"
#import "LdayView.h"

@interface CalendarListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NJUTListEventsCDTVCDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *calendarListCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *calendarListTableViewHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *calendarListDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noClassImageView;
@property (strong, nonatomic) CoreDataTableViewController *CDTVC;
@property (strong, nonatomic) NJUTListEventsCDTVC *NJUTListCDTVC;
@property (strong, nonatomic) NSIndexPath *LselectIndexPath;
@property (nonatomic) NSInteger Lmonth;
@property (nonatomic) NSInteger Lyear;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) BOOL isInSemester;
@end

@implementation CalendarListViewController

- (CoreDataTableViewController *)CDTVC
{
    if (!_CDTVC) {
        _CDTVC = [[CoreDataTableViewController alloc] init];
    }
    return _CDTVC;
}

- (NJUTListEventsCDTVC *)NJUTListCDTVC
{
    if (!_NJUTListCDTVC) {
        _NJUTListCDTVC = [[NJUTListEventsCDTVC alloc] init];
    }
    return _NJUTListCDTVC;
}

#define START_DAY 1
#define START_MONTH 1
#define START_YEAR 1984

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger items = [self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:31 Month:12 Year:2039];

    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Lday"
                                                                           forIndexPath:indexPath];
    NSArray *LdateArray = [self.calendarCalculator dateWithIndex:indexPath.item
                                                           today:START_DAY
                                                         toMonth:START_MONTH
                                                          toYear:START_YEAR];
    NSString *LdayString = [LdateArray objectAtIndex:0];
    NSString *LweekString = [LdateArray objectAtIndex:1];
    if ([LweekString isEqualToString:@"-1"]) {
        LweekString = @"6";
    } else if ([LweekString isEqualToString:@"0"]) {
        LweekString = @"7";
    }
    
    CGPoint translation = [collectionView.panGestureRecognizer translationInView:collectionView];
    
    NSInteger Lday = [[LdateArray objectAtIndex:0] integerValue];
    NSInteger Lmonth = [[LdateArray objectAtIndex:2] integerValue];
    NSInteger Lyear = [[LdateArray objectAtIndex:3] integerValue];
    NSInteger numberOfWeekInTheSemester = [self.calendarCalculator whichWeekOfTheSemester:[NSString stringWithFormat:@"%d-%d-%d", Lyear, Lmonth, Lday]];
    if (numberOfWeekInTheSemester > 0 && numberOfWeekInTheSemester < 21) {
        self.isInSemester = YES;
    } else {
        self.isInSemester = NO;
    }
    
    if ([[LdateArray objectAtIndex:2] integerValue] != self.Lmonth ||
        [[LdateArray objectAtIndex:3] integerValue] != self.Lyear) {
        self.Lmonth = [[LdateArray objectAtIndex:2] integerValue];
        self.Lyear = [[LdateArray objectAtIndex:3] integerValue];
        if (!self.isInSemester) {
            NSString *yearAndMonth = [NSString stringWithFormat:@"%d 年 %d 月", self.Lyear, self.Lmonth];
            [self.delegate calendarListViewController:self didUpdateYearAndMonth:yearAndMonth];
        }
    }
    
    if (self.isInSemester) {
        if (translation.x > 0) {
            NSString *numberOfWeekInTheSemesterString = [NSString stringWithFormat:@"第 %d 周", numberOfWeekInTheSemester + 1];
            [self.delegate calendarListViewController:self didUpdateYearAndMonth:numberOfWeekInTheSemesterString];
        } else {
            NSString *numberOfWeekInTheSemesterString = [NSString stringWithFormat:@"第 %d 周", numberOfWeekInTheSemester];
            [self.delegate calendarListViewController:self didUpdateYearAndMonth:numberOfWeekInTheSemesterString];
        }
    } else {
        NSString *yearAndMonth = [NSString stringWithFormat:@"%d 年 %d 月", self.Lyear, self.Lmonth];
        [self.delegate calendarListViewController:self didUpdateYearAndMonth:yearAndMonth];
    }
    
    [self updateCell:cell usingDayString:LdayString andWeekString:LweekString andIndexPath:indexPath];
    if (!(indexPath.item == self.selectedIndex)) {
        [self LclearHighlightOfCell:cell];
    } else if (indexPath.item == self.selectedIndex) {
        [self LhighlightCell:cell withWeek:LweekString];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.LselectIndexPath = indexPath;
    if (!indexPath) {
        indexPath = [NSIndexPath indexPathForItem:self.selectedIndex inSection:0];
    }
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    NSArray *LdateArray = [self.calendarCalculator dateWithIndex:indexPath.item
                                                           today:START_DAY
                                                         toMonth:START_MONTH
                                                          toYear:START_YEAR];
    NSString *LweekString = [LdateArray objectAtIndex:1];
    if ([LweekString isEqualToString:@"-1"]) {
        LweekString = @"6";
    } else if ([LweekString isEqualToString:@"0"]) {
        LweekString = @"7";
    }
    
    if ([[LdateArray objectAtIndex:2] integerValue] != self.Lmonth ||
        [[LdateArray objectAtIndex:3] integerValue] != self.Lyear) {
        self.Lmonth = [[LdateArray objectAtIndex:2] integerValue];
        self.Lyear = [[LdateArray objectAtIndex:3] integerValue];
    }
    self.selectedIndex = indexPath.item;
    [self LupdateTableViewUsingIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self LhighlightCell:cell withWeek:LweekString];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self LclearHighlightOfCell:cell];
}

- (void)LhighlightCell:(UICollectionViewCell *)cell withWeek:(NSString *)weekString
{
    if ([cell isKindOfClass:[CalendarListCollectionCell class]]) {
        if (cell.selected) {
            [self LclearHighlightOfCell:cell];
            //LdayView *LdayView = ((CalendarListCollectionCell *)cell).LdayView;
            //[LdayView animateWeek];
            //int randomNumber = (arc4random() % 3) + 1;
            //UIImage *randomCircleImage = [UIImage imageNamed:[NSString stringWithFormat:@"calendar_month_overlay-%u.png", randomNumber]];
            //UIImageView *imageView = [[UIImageView alloc] initWithImage:randomCircleImage];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_day_overlay.png"]];
            imageView.frame = CGRectMake(3, 2, imageView.frame.size.width, imageView.frame.size.height);
            [cell addSubview:imageView];
        }
    }
}

- (void)LclearHighlightOfCell:(UICollectionViewCell *)cell
{
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)LupdateTableViewUsingIndexPath:(NSIndexPath *)indexPath
{
    self.NJUTListCDTVC.isTodaySelected = NO;
    self.NJUTListCDTVC.isTomorrowSelected = NO;
    NSArray *LdateArray = [self.calendarCalculator dateWithIndex:indexPath.item
                                                           today:START_DAY
                                                         toMonth:START_MONTH
                                                          toYear:START_YEAR];
    NSInteger Lweek = [[LdateArray objectAtIndex:1] integerValue];
    if (Lweek == -1) {
        Lweek = 6;
    } else if (Lweek == 0) {
        Lweek = 7;
    }
    NSInteger Lday = [[LdateArray objectAtIndex:0] integerValue];
    NSInteger Lmonth = [[LdateArray objectAtIndex:2] integerValue];
    NSInteger Lyear = [[LdateArray objectAtIndex:3] integerValue];
    NSInteger numberOfWeekInTheSemester = [self.calendarCalculator whichWeekOfTheSemester:[NSString stringWithFormat:@"%d-%d-%d", Lyear, Lmonth, Lday]];
    if (indexPath.item == [NSIndexPath indexPathForItem:[self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:self.today Month:self.tomonth Year:self.toyear] inSection:0].item) {
        self.calendarListDateLabel.text = @"今天";
        self.NJUTListCDTVC.isTodaySelected = YES;
    } else if (indexPath.item == [NSIndexPath indexPathForItem:[self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:self.today Month:self.tomonth Year:self.toyear] inSection:0].item + 1) {
        self.calendarListDateLabel.text = @"明天";
        self.NJUTListCDTVC.isTomorrowSelected = YES;
    } else if (indexPath.item == [NSIndexPath indexPathForItem:[self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:self.today Month:self.tomonth Year:self.toyear] inSection:0].item + 2) {
        self.calendarListDateLabel.text = @"后天";
    } else {
        self.calendarListDateLabel.text = [NSString stringWithFormat:@"%d/%d/%d", Lyear, Lmonth, Lday];
    }
    if (numberOfWeekInTheSemester > 0 && numberOfWeekInTheSemester < 21) {
        self.calendarListTableViewHeaderLabel.text = [NSString stringWithFormat:@"第%d周", numberOfWeekInTheSemester];
        NSString *yearAndMonth = [NSString stringWithFormat:@"第 %d 周", numberOfWeekInTheSemester];;
        [self.delegate calendarListViewController:self didUpdateYearAndMonth:yearAndMonth];
    } else {
        self.calendarListTableViewHeaderLabel.text = @"";
        NSString *yearAndMonth = [NSString stringWithFormat:@"%d 年 %d 月", Lyear, Lmonth];;
        [self.delegate calendarListViewController:self didUpdateYearAndMonth:yearAndMonth];
    }
    self.NJUTListCDTVC.todayOfTheWeek = Lweek;
    if (numberOfWeekInTheSemester % 2 == 1) {
        self.NJUTListCDTVC.weekProperty = @"单";
    } else if (numberOfWeekInTheSemester % 2 == 0) {
        self.NJUTListCDTVC.weekProperty = @"双";
    }
    self.NJUTListCDTVC.numberOfWeekInTheSemester = numberOfWeekInTheSemester;
    self.NJUTListCDTVC.managedObjectContext = self.managedObjectContext;
    
    if (self.NJUTListCDTVC.numberOfEvents == 0) {
        self.noClassImageView.hidden = NO;
        if (numberOfWeekInTheSemester <= 0 || numberOfWeekInTheSemester >= 21) {
            self.noClassImageView.image = [UIImage imageNamed:@"vacation_face.png"];
        } else {
            self.noClassImageView.image = [UIImage imageNamed:@"no_class_face.png"];
        }
    } else {
        self.noClassImageView.hidden = YES;
    }
    
    NSArray *LtomorrowDateArray = [self.calendarCalculator dateWithIndex:indexPath.item + 1
                                                                   today:START_DAY
                                                                 toMonth:START_MONTH
                                                                  toYear:START_YEAR];
    NSInteger LtomorrowDay = [[LtomorrowDateArray objectAtIndex:0] integerValue];
    NSInteger LtomorrowMonth = [[LtomorrowDateArray objectAtIndex:2] integerValue];
    NSInteger LtomorrowYear = [[LtomorrowDateArray objectAtIndex:3] integerValue];
    self.NJUTListCDTVC.tomorrowDateString = [NSString stringWithFormat:@"%d/%d/%d", LtomorrowYear, LtomorrowMonth, LtomorrowDay];
    NSArray *LtheDayAfterTomorrowDateArray = [self.calendarCalculator dateWithIndex:indexPath.item + 2
                                                                              today:START_DAY
                                                                            toMonth:START_MONTH
                                                                             toYear:START_YEAR];
    NSInteger LtheDayAfterTomorrowDay = [[LtheDayAfterTomorrowDateArray objectAtIndex:0] integerValue];
    NSInteger LtheDayAfterTomorrowMonth = [[LtheDayAfterTomorrowDateArray objectAtIndex:2] integerValue];
    NSInteger LtheDayAfterTomorrowYear = [[LtheDayAfterTomorrowDateArray objectAtIndex:3] integerValue];
    self.NJUTListCDTVC.theDayAfterTomorrowDateString = [NSString stringWithFormat:@"%d/%d/%d", LtheDayAfterTomorrowYear, LtheDayAfterTomorrowMonth, LtheDayAfterTomorrowDay];
    
    if (Lyear > self.toyear) {
        self.NJUTListCDTVC.isFuture = YES;
    } else if (Lyear == self.toyear && Lmonth > self.tomonth) {
        self.NJUTListCDTVC.isFuture = YES;
    } else if (Lyear == self.toyear && Lmonth == self.tomonth && Lday > self.today) {
        self.NJUTListCDTVC.isFuture = YES;
    } else {
        self.NJUTListCDTVC.isFuture = NO;
    }
    
    if (Lyear < self.toyear) {
        self.NJUTListCDTVC.isPast = YES;
    } else if (self.year == self.toyear && self.month < self.tomonth) {
        self.NJUTListCDTVC.isPast = YES;
    } else if (self.year == self.toyear && self.month == self.tomonth && self.day < self.today) {
        self.NJUTListCDTVC.isPast = YES;
    } else {
        self.NJUTListCDTVC.isPast = NO;
    }
}

- (void)updateCell:(UICollectionViewCell *)cell
    usingDayString:(NSString *)dayString
     andWeekString:(NSString *) weekString
      andIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CalendarListCollectionCell class]]) {
        LdayView *LdayView = ((CalendarListCollectionCell *)cell).LdayView;
        LdayView.dayString = dayString;
        LdayView.weekString = weekString;
        if ([indexPath compare:[NSIndexPath indexPathForItem:[self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:self.today Month:self.tomonth Year:self.toyear] inSection:0]] == NSOrderedSame) {
            LdayView.isTodayString = YES;
        } else {
            LdayView.isTodayString = NO;
        }
        
        NSString *weekProperty;
        NSInteger numberOfWeekInTheSemester = [self.calendarCalculator whichWeekOfTheSemester:[NSString stringWithFormat:@"%d-%d-%d", self.Lyear, self.Lmonth, [dayString integerValue]]];
        if (numberOfWeekInTheSemester % 2 == 1) {
            weekProperty = @"单";
        } else if (numberOfWeekInTheSemester % 2 == 0) {
            weekProperty = @"双";
        }
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timeToken" ascending:YES]];
        if ([weekProperty isEqualToString:@"单"]) {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d && endWeek >= %d) && weekProperty IN { ' ', '单', '' }", [weekString integerValue], numberOfWeekInTheSemester, numberOfWeekInTheSemester];
        } else if ([weekProperty isEqualToString:@"双"]) {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d && endWeek >= %d) && weekProperty IN { ' ', '双', '' }", [weekString integerValue], numberOfWeekInTheSemester, numberOfWeekInTheSemester];
        } else {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d)", [weekString integerValue], numberOfWeekInTheSemester];
        }
        self.CDTVC.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        if ([self.CDTVC.fetchedResultsController.fetchedObjects count]) {
            LdayView.haveEvent = YES;
        } else {
            LdayView.haveEvent = NO;
        }
        
        [LdayView refreshView];
    }
}

- (void)performToday
{
    [self collectionView:self.calendarListCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    [self.calendarListCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:self.today Month:self.tomonth Year:self.toyear] - self.toweekday + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self collectionView:self.calendarListCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:[self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:self.today Month:self.tomonth Year:self.toyear] inSection:0]];
}

- (void)LreloadSelectedCell
{
    NSLog(@"%@", self.selectIndexPath);
    [self collectionView:self.calendarListCollectionView didSelectItemAtIndexPath:self.selectIndexPath];
}

- (void)LdocumentIsReady
{
    NSArray *cellArray = [self.calendarListCollectionView visibleCells];
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
        [self.calendarListCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:self.today Month:self.tomonth Year:self.toyear] - self.toweekday + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        [self collectionView:self.calendarListCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:[self.calendarCalculator howManyDaysBetweenStartDay:START_DAY Month:START_MONTH Year:START_YEAR andEndDay:self.today Month:self.tomonth Year:self.toyear] inSection:0]];
    }
}

- (void)displaySummaryViewWithCtid:(NSString *)ctid andStartTime:(NSString *)startTime
{
    [self.delegate displaySummaryWithCtid:ctid andStartTime:startTime];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self LdocumentIsReady];
    
    [self.view layoutSubviews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed List Events"]) {
        if ([segue.destinationViewController isKindOfClass:[NJUTListEventsCDTVC class]]) {
            self.NJUTListCDTVC = segue.destinationViewController;
            self.NJUTListCDTVC.delegate = self;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendarListCollectionView.delegate = self;
    self.Lmonth = self.month;
    self.Lyear = self.year;
    
    //UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bar_bg.png"]];
    //self.calendarListCollectionView.backgroundView = bgView;
}

@end
