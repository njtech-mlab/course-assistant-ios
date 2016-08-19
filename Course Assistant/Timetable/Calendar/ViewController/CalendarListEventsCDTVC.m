//
//  CalendarListEventsCDTVC.m
//  南工课立方
//
//  Created by Jason J on 13-5-9.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarListEventsCDTVC.h"
#import "CalendarListTableViewCell.h"
#import "Course.h"
#import "User.h"

@interface CalendarListEventsCDTVC ()
@property (nonatomic) BOOL sectionOne;
@property (nonatomic) BOOL sectionTwo;
@property (nonatomic) BOOL sectionThree;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSIndexPath *preSelectedIndexPath;
@end

@implementation CalendarListEventsCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    self.selectedIndexPath = nil;
    self.preSelectedIndexPath = nil;
    if (managedObjectContext) {
        self.tomorrowOfTheWeek = self.todayOfTheWeek + 1;
        if (self.tomorrowOfTheWeek > 7) {
            self.tomorrowOfTheWeek = 1;
            self.numberOfWeekInTheSemester ++;
            self.theDayAfterTomorrowOfTheWeek = self.tomorrowOfTheWeek + 1;
        } else {
            self.theDayAfterTomorrowOfTheWeek = self.tomorrowOfTheWeek + 1;
            if (self.theDayAfterTomorrowOfTheWeek > 7) {
                self.theDayAfterTomorrowOfTheWeek = 1;
                self.numberOfWeekInTheSemester ++;
            }
        }
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"timeToken" ascending:YES]];
        if ([self.weekProperty isEqualToString:@"单"]) {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d && endWeek >= %d) && weekProperty IN { ' ', '单', '' }", self.todayOfTheWeek, self.numberOfWeekInTheSemester, self.numberOfWeekInTheSemester];
        } else if ([self.weekProperty isEqualToString:@"双"]) {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d && endWeek >= %d) && weekProperty IN { ' ', '双', '' }", self.todayOfTheWeek, self.numberOfWeekInTheSemester, self.numberOfWeekInTheSemester];
        } else {
            request.predicate = [NSPredicate predicateWithFormat:@"day = %d && (startWeek <= %d)", self.todayOfTheWeek, self.numberOfWeekInTheSemester];
        }
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:@"day"
                                                                                       cacheName:nil];
        self.numberOfEvents = [self.fetchedResultsController.fetchedObjects count];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
    /*
    self.sectionOne = NO;
    self.sectionTwo = NO;
    self.sectionThree = NO;
    if (!self.fetchedResultsController) {
        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    } else {
        if ([self.fetchedResultsController.sections count] == 0) {
            return 1;
        } else if ([self.fetchedResultsController.sections count] == 1) {
            NSInteger fetchedDayOfTheWeek = [[self.fetchedResultsController.sectionIndexTitles lastObject] integerValue];
            if (fetchedDayOfTheWeek == self.todayOfTheWeek) {
                self.sectionTwo = YES;
                self.sectionThree = YES;
                if (section == 0) {
                    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
                } else {
                    return 1;
                }
            } else if ((fetchedDayOfTheWeek - self.todayOfTheWeek) == 1) {
                self.sectionOne = YES;
                self.sectionThree = YES;
                if (section == 1) {
                    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
                } else {
                    return 1;
                }
            } else if ((fetchedDayOfTheWeek - self.todayOfTheWeek) == 2 || (fetchedDayOfTheWeek - self.todayOfTheWeek) == -5) {
                self.sectionOne = YES;
                self.sectionTwo = YES;
                if (section == 2) {
                    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
                } else {
                    return 1;
                }
            } else {
                self.sectionOne = YES;
                self.sectionThree = YES;
                if (section == 1) {
                    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
                } else {
                    return 1;
                }
            }
        } else if ([self.fetchedResultsController.sections count] == 2) {
            NSInteger fetchedDayOfTheWeek1 = [[self.fetchedResultsController.sectionIndexTitles objectAtIndex:0] integerValue];
            NSInteger fetchedDayOfTheWeek2 = [[self.fetchedResultsController.sectionIndexTitles objectAtIndex:1] integerValue];
            if (fetchedDayOfTheWeek1 == self.todayOfTheWeek) {
                self.sectionThree = YES;
                if (section == 2) {
                    return 1;
                } else {
                    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
                }
            } else if (fetchedDayOfTheWeek1 < self.todayOfTheWeek && fetchedDayOfTheWeek2 > self.todayOfTheWeek) {
                self.sectionTwo = YES;
                if (section == 1) {
                    return 1;
                } else {
                    if (section == 0) {
                        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
                    } else {
                        return [[[self.fetchedResultsController sections] objectAtIndex:section - 1] numberOfObjects];
                    }
                }
            } else {
                self.sectionOne = YES;
                if (section == 0) {
                    return 1;
                } else {
                    return [[[self.fetchedResultsController sections] objectAtIndex:section - 1] numberOfObjects];
                }
            }
        } else {
            return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
        }
    }
    */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CalendarListTableViewCell";
    CalendarListTableViewCell *cell = (CalendarListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
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
    [CalendarListEventsCDTVC classInfoCell:cell cellForCourse:course];
    /*
    if ([self.fetchedResultsController.sections count] == 3) {
        Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [CalendarListEventsCDTVC classInfoCell:cell cellForCourse:course];
    } else if ([self.fetchedResultsController.sections count] == 2) {
        if (self.sectionOne) {
            if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:0]] == NSOrderedSame) {
                [CalendarListEventsCDTVC noClassCell:cell];
            } else {
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
                Course *course = [self.fetchedResultsController objectAtIndexPath:indexP];
                [CalendarListEventsCDTVC classInfoCell:cell cellForCourse:course];
            }
        } else if (self.sectionTwo) {
            if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:1]] == NSOrderedSame) {
                [CalendarListEventsCDTVC noClassCell:cell];
            } else {
                NSIndexPath *indexP;
                if (indexPath.section == 0) {
                    indexP = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                } else if (indexPath.section == 2) {
                    indexP = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
                }
                Course *course = [self.fetchedResultsController objectAtIndexPath:indexP];
                [CalendarListEventsCDTVC classInfoCell:cell cellForCourse:course];
            }
        } else if (self.sectionThree) {
            if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:2]] == NSOrderedSame) {
                [CalendarListEventsCDTVC noClassCell:cell];
            } else {
                Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [CalendarListEventsCDTVC classInfoCell:cell cellForCourse:course];
            }
        }
    } else if ([self.fetchedResultsController.sections count] == 1) {
        if (!self.sectionOne) {
            if (indexPath.section == 0) {
                Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
                [CalendarListEventsCDTVC classInfoCell:cell cellForCourse:course];
            } else {
                [CalendarListEventsCDTVC noClassCell:cell];
            }
        } else if (!self.sectionTwo) {
            if (indexPath.section == 1) {
                Course *course = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                [CalendarListEventsCDTVC classInfoCell:cell cellForCourse:course];
            } else {
                [CalendarListEventsCDTVC noClassCell:cell];
            }
        } else if (!self.sectionThree) {
            if (indexPath.section == 2) {
                Course *course = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                [CalendarListEventsCDTVC classInfoCell:cell cellForCourse:course];
            } else {
                [CalendarListEventsCDTVC noClassCell:cell];
            }
        }
    } else {
        [CalendarListEventsCDTVC noClassCell:cell];
    }
    */
    
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

+ (void)classInfoCell:(CalendarListTableViewCell *)cell cellForCourse:(Course *)course
{
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
    cell.noClassLabel.text = nil;
    cell.userInteractionEnabled = YES;
}

+ (void)noClassCell:(CalendarListTableViewCell *)cell
{
    cell.courseNameLabel.text = nil;
    cell.classroomLocationLabel.text = nil;
    cell.classTimeLabel.text = nil;
    cell.teacherLabel.text = nil;
    cell.circleImageView.image = nil;
    cell.noClassLabel.text = @"这天没有课哟 😃";
    cell.userInteractionEnabled = NO;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.fetchedResultsController.sections count] == 2) {
        if (self.sectionOne) {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
        } else if (self.sectionTwo) {
            if (indexPath.section == 0) {
                indexPath = indexPath;
            } else if (indexPath.section == 2) {
                indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
            }
        } else if (self.sectionThree) {
            indexPath = indexPath;
        }
    } else if ([self.fetchedResultsController.sections count] == 1) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    }
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.ctid = course.ctid;
    self.courseName = course.name;
    self.courseProperty = course.courseProperty;
    self.credit = course.credit;
    self.endTime = course.endTime;
    self.startTime = course.startTime;
    self.teacherName = course.teacherName;
    
    if (indexPath.section) {
        self.isFuture = YES;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarListTableViewCell *calendarTableViewCell = (CalendarListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 25;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    if (section) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        UIImage *headerImage = [UIImage imageNamed:@"event-header-background.png"];
        headerView.backgroundColor = [UIColor colorWithPatternImage:headerImage];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 100, 21)];
        dateLabel.font = [UIFont systemFontOfSize:12.0];
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        if (self.isTodaySelected) {
            dateLabel.text = @"明天";
            self.isTodaySelected = NO;
        } else if (self.isTomorrowSelected) {
            dateLabel.text = @"后天";
            self.isTomorrowSelected = NO;
        } else {
            dateLabel.text = self.tomorrowDateString;
        }
        if (section == 2) {
            if (self.isTodaySelected) {
                dateLabel.text = @"后天";
                self.isTodaySelected = NO;
            } else {
                dateLabel.text = self.theDayAfterTomorrowDateString;
            }
        }
        [headerView addSubview:dateLabel];
    } else {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return headerView;
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
