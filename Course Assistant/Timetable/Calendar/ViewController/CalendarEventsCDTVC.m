//
//  CalendarEventsCDTVC.m
//  云知易课堂
//
//  Created by Jason J on 13-4-11.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarEventsCDTVC.h"
#import "CalendarTableViewCell.h"
#import "Course.h"
#import "User.h"

@interface CalendarEventsCDTVC ()
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSIndexPath *preSelectedIndexPath;
@end

@implementation CalendarEventsCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    self.selectedIndexPath = nil;
    self.preSelectedIndexPath = nil;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timeToken" ascending:YES]];
        if ([self.weekProperty isEqualToString:@"单"]) {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d && endWeek >= %d) && weekProperty IN { ' ', '单', '' }", self.dayOfTheWeek, self.numberOfWeekInTheSemester, self.numberOfWeekInTheSemester];
        } else if ([self.weekProperty isEqualToString:@"双"]) {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d && endWeek >= %d) && weekProperty IN { ' ', '双', '' }", self.dayOfTheWeek, self.numberOfWeekInTheSemester, self.numberOfWeekInTheSemester];
        } else {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d)", self.dayOfTheWeek, self.numberOfWeekInTheSemester];
        }
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        self.numberOfEvents = [self.fetchedResultsController.fetchedObjects count];
        NSMutableArray *todayEventsMutableArray = [[NSMutableArray alloc] init];
        for (Course *course in self.fetchedResultsController.fetchedObjects) {
            [todayEventsMutableArray addObject:[course dictionaryWithValuesForKeys:[[[course entity] attributesByName] allKeys]]];
        }
        NSArray *todayEventsArray = [todayEventsMutableArray copy];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:todayEventsArray] forKey:@"todayEventsArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CalendarTableViewCell";
    CalendarTableViewCell *cell = (CalendarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                           forIndexPath:indexPath];
    
    // Configure the cell
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == 80) {
            for (UIView *subview in view.subviews) {
                [subview removeFromSuperview];
            }
            [view removeFromSuperview];
        }
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.courseNameLabel.textColor = [UIColor blackColor];
    cell.classroomLocationLabel.textColor = [UIColor blackColor];
    cell.classTimeLabel.textColor = [UIColor blackColor];
    cell.teacherLabel.textColor = [UIColor blackColor];
    
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.courseNameLabel.text = course.name;
    cell.classroomLocationLabel.text = course.classroom;
    cell.classTimeLabel.text = course.time;
    cell.teacherLabel.text = course.teacherName;
    
    if ([course.courseProperty rangeOfString:@"全校性"].location == NSNotFound && [course.courseProperty rangeOfString:@"选课"].location == NSNotFound && [course.courseProperty rangeOfString:@"通识"].location == NSNotFound) {
        cell.lineImageView.image = [UIImage imageNamed:@"circle_blue.png"];
    } else if ([course.courseProperty rangeOfString:@"选课"].location == NSNotFound && [course.courseProperty rangeOfString:@"必修"].location == NSNotFound) {
        cell.lineImageView.image = [UIImage imageNamed:@"circle_red.png"];
    } else if ([course.courseProperty rangeOfString:@"全校性"].location == NSNotFound && [course.courseProperty rangeOfString:@"必修"].location == NSNotFound && [course.courseProperty rangeOfString:@"通识"].location == NSNotFound) {
        cell.lineImageView.image = [UIImage imageNamed:@"circle_green.png"];
    }
    
    if (self.selectedIndexPath) {
        if ([self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1];
            cell.courseNameLabel.textColor = [UIColor whiteColor];
            cell.classroomLocationLabel.textColor = [UIColor whiteColor];
            cell.classTimeLabel.textColor = [UIColor whiteColor];
            cell.teacherLabel.textColor = [UIColor whiteColor];
            cell.lineImageView.image = [UIImage imageNamed:@"circle_white.png"];
            UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 40)];
            buttonView.tag = 80;
            buttonView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1];
            [cell.contentView addSubview:buttonView];
            if (self.isTodaySelected) {
                UIImage *starImage = [UIImage imageNamed:@"star_icon"];
                UIImage *penImage = [UIImage imageNamed:@"pen_icon"];
                UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 6, starImage.size.width * 0.7, starImage.size.height * 0.7)];
                starImageView.image = starImage;
                UIImageView *penImageView = [[UIImageView alloc] initWithFrame:CGRectMake(190, 6, penImage.size.width * 0.7, penImage.size.height * 0.7)];
                penImageView.image = penImage;
                [buttonView addSubview:starImageView];
                [buttonView addSubview:penImageView];
                
                UIButton *evaluationButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 6, 120, starImageView.frame.size.height)];
                [evaluationButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"小结" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
                [evaluationButton addTarget:self action:@selector(evaluationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                UIButton *summaryButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 6, 120, starImageView.frame.size.height)];
                [summaryButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"感受" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0]  }] forState:UIControlStateNormal];
                [summaryButton addTarget:self action:@selector(summaryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [buttonView addSubview:evaluationButton];
                [buttonView addSubview:summaryButton];
            } else {
                UILabel *forbiddenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 320, 21)];
                forbiddenLabel.text = @"现在不能反馈哦~";
                forbiddenLabel.backgroundColor = [UIColor clearColor];
                forbiddenLabel.textAlignment = NSTextAlignmentCenter;
                forbiddenLabel.textColor = [UIColor whiteColor];
                forbiddenLabel.font = [UIFont systemFontOfSize:15.0];
                [buttonView addSubview:forbiddenLabel];
            }
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.ctid = course.ctid;
    self.courseName = course.name;
    self.courseProperty = course.courseProperty;
    self.credit = course.credit;
    self.endTime = course.endTime;
    self.startTime = course.startTime;
    self.teacherName = course.teacherName;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarTableViewCell *calendarTableViewCell = (CalendarTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (calendarTableViewCell.frame.size.height > 50.0) {
        self.selectedIndexPath = nil;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        self.selectedIndexPath = indexPath;
        if ([self.preSelectedIndexPath compare:indexPath] != NSOrderedSame) {
            [tableView reloadRowsAtIndexPaths:@[indexPath, self.preSelectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50.0;
    
    if (self.selectedIndexPath) {
        if ([self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
            height = 90.0;
            self.preSelectedIndexPath = indexPath;
        } else {
            height = 50.0;
        }
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (![self.fetchedResultsController.fetchedObjects count]) {
        return 0.01f;
    } else {
        return 0;
    }
}

- (IBAction)evaluationButtonPressed:(id)sender
{
    // abstract
}

- (IBAction)summaryButtonPressed:(id)sender
{
    // abstract
}

@end
