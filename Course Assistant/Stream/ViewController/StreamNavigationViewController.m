//
//  StreamNavigationViewController.m
//  课程助理
//
//  Created by Jason J on 9/16/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import "StreamNavigationViewController.h"
#import "ECSlidingViewController.h"
#import "NavigationViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "EvaluationTVC.h"
#import "StreamEvaluationButton.h"
#import "EvaluationTextView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIManagedDocumentHandler.h"
#import "CoreDataTableViewController.h"
#import "Course.h"
#import "CalendarCalculator.h"

@interface StreamNavigationViewController () <ASIHTTPRequestDelegate>
@property (strong, nonatomic) UIView *blackView;
@property (strong, nonatomic) UIImageView *popoverImageView;
@property (strong, nonatomic) UIView *summaryView;
@property (strong, nonatomic) UIView *blackView2;
@property (strong, nonatomic) UITextView *summaryTextView;
@property (strong, nonatomic) UIButton *summaryCancelButton;
@property (strong, nonatomic) UIButton *summaryDoneButton;
@property (strong, nonatomic) NSString *summaryCtid;
@property (strong, nonatomic) NSString *summaryStartTime;
@property (strong, nonatomic) NSString *weekProperty;
@property (nonatomic) NSInteger dayOfTheWeek;
@property (nonatomic) NSInteger numberOfWeekInTheSemester;
@property (strong, nonatomic) CalendarCalculator *calendarCalculator;
@property (strong, nonatomic) CoreDataTableViewController *CDTVC;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id <UIManagedDocumentHandlerDelegate> managedDocumentHandlerDelegate;
@end

@implementation StreamNavigationViewController

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

- (CoreDataTableViewController *)CDTVC
{
    if (!_CDTVC) {
        _CDTVC = [[CoreDataTableViewController alloc] init];
    }
    return _CDTVC;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
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
        self.CDTVC.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                  managedObjectContext:managedObjectContext
                                                                                    sectionNameKeyPath:nil
                                                                                             cacheName:nil];
        NSMutableArray *todayEventsMutableArray = [[NSMutableArray alloc] init];
        for (Course *course in self.CDTVC.fetchedResultsController.fetchedObjects) {
            [todayEventsMutableArray addObject:[course dictionaryWithValuesForKeys:[[[course entity] attributesByName] allKeys]]];
        }
        NSArray *todayEventsArray = [todayEventsMutableArray copy];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:todayEventsArray] forKey:@"todayEventsArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.CDTVC.fetchedResultsController = nil;
    }
}

- (void)removeSummaryViewToSend
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView2.alpha = 0;
            self.summaryView.frame = CGRectMake(20, -(self.view.frame.size.height - 252 - 40), 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.summaryView removeFromSuperview];
                [self.blackView2 removeFromSuperview];
                self.summaryView = nil;
                self.blackView2 = nil;
            }
        }];
    } else {
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView2.alpha = 0;
            self.summaryView.frame = CGRectMake(20, -(self.view.frame.size.height - 252 - 40), 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.summaryView removeFromSuperview];
                [self.blackView2 removeFromSuperview];
                self.summaryView = nil;
                self.blackView2 = nil;
            }
        }];
    }
    
    [self.summaryTextView resignFirstResponder];
    self.summaryTextView = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error.localizedDescription);
    [self showErrorAlertUsingString:@"提交失败，请检查网络。"];
    self.summaryCancelButton.enabled = YES;
    self.summaryDoneButton.enabled = YES;
    self.summaryTextView.editable = YES;
    [self.summaryTextView becomeFirstResponder];
}

- (void)summaryRequestDidFinishLoading:(ASIHTTPRequest *)request
{
    NSData *requestData = [request responseData];
    if (requestData) {
        NSDictionary *result = nil;
        NSError *error = nil;
        result = [NSJSONSerialization JSONObjectWithData:requestData
                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                   error:&error];
        [self showErrorAlertUsingString:[result valueForKey:@"msg"]];
        [self removeSummaryViewToSend];
    } else {
        [self showErrorAlertUsingString:@"提交失败，请检查网络。"];
        self.summaryCancelButton.enabled = YES;
        self.summaryDoneButton.enabled = YES;
        self.summaryTextView.editable = YES;
        [self.summaryTextView becomeFirstResponder];
    }
}

#define SUMMARY_URL @"http://app.njut.org.cn/timetable/spit.action"
#define POST_SUMMARY_FORMAT @"schoolnumber=%@&ctid=%@&content=%@&starttime=%@"

- (void)startConnectingWithPostSummaryBySchoolNumber:(NSString *)schoolnumber ctid:(NSString *)ctid content:(NSString *)content startTime:(NSString *)startTime
{
    self.summaryCancelButton.enabled = NO;
    self.summaryDoneButton.enabled = NO;
    self.summaryTextView.editable = NO;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SUMMARY_URL]];
    [request setPostValue:schoolnumber forKey:@"schoolnumber"];
    [request setPostValue:ctid forKey:@"ctid"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:startTime forKey:@"starttime"];
    [request setRequestMethod:@"POST"];
    request.delegate = self;
    request.didFinishSelector = @selector(summaryRequestDidFinishLoading:);
    request.timeOutSeconds = 20;
    [request startAsynchronous];
}

- (void)sendSummaryContent
{
    if ([self.summaryTextView text].length != 0) {
        [self startConnectingWithPostSummaryBySchoolNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"] ctid:self.summaryCtid content:[self.summaryTextView text] startTime:self.summaryStartTime];
    } else {
        [self removeSummaryView];
    }
}

- (void)removeSummaryView
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView2.alpha = 0;
            self.summaryView.frame = CGRectMake(20, self.view.frame.size.height, 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.summaryView removeFromSuperview];
                [self.blackView2 removeFromSuperview];
                self.summaryView = nil;
                self.blackView2 = nil;
            }
        }];
    } else {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView2.alpha = 0;
            self.summaryView.frame = CGRectMake(20, self.view.frame.size.height, 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.summaryView removeFromSuperview];
                [self.blackView2 removeFromSuperview];
                self.summaryView = nil;
                self.blackView2 = nil;
            }
        }];
    }
    
    [self.summaryTextView resignFirstResponder];
    self.summaryTextView = nil;
}

#define PLACEHOLDER @"觉得今天的课上的怎样？还有哪些地方需要改进？把你的想法告诉老师吧！（200字以内）"

- (void)displaySummaryWithCtid:(NSString *)ctid andStartTime:(NSString *)startTime
{
    self.blackView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.blackView2.backgroundColor = [UIColor blackColor];
    self.blackView2.alpha = 0;
    [self.view addSubview:self.blackView2];
    
    UIView *summaryBackgroundView = [[UIView alloc] init];
    [self.view addSubview:summaryBackgroundView];
    summaryBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    summaryBackgroundView.layer.cornerRadius = 10.0;
    summaryBackgroundView.frame = CGRectMake(20, self.view.frame.size.height, 280, self.view.frame.size.height - 252 - 40);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 80, 20)];
    titleLabel.text = @"感受";
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [summaryBackgroundView addSubview:titleLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 60, 30)];
    [cancelButton addTarget:self action:@selector(removeSummaryView) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"取消" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:17.0] }] forState:UIControlStateNormal];
    [cancelButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"取消" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:17.0] }] forState:UIControlStateHighlighted];
    [summaryBackgroundView addSubview:cancelButton];
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 6, 60, 30)];
    [doneButton addTarget:self action:@selector(sendSummaryContent) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"提交" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:123.0/255.0 blue:243.0/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:17.0] }] forState:UIControlStateNormal];
    [doneButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"提交" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:17.0] }] forState:UIControlStateHighlighted];
    [summaryBackgroundView addSubview:doneButton];
    
    EvaluationTextView *textView = [[EvaluationTextView alloc] initWithFrame:CGRectMake(10, 40, 260, self.view.frame.size.height - 252 - 90)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = PLACEHOLDER;
    textView.placeholderColor = [UIColor lightGrayColor];
    textView.textColor = [UIColor darkGrayColor];
    textView.font = [UIFont systemFontOfSize:15.0];
    [summaryBackgroundView addSubview:textView];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView2.alpha = 0.5;
            summaryBackgroundView.frame = CGRectMake(20, 30, 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                self.summaryView = summaryBackgroundView;
                self.summaryTextView = textView;
                self.summaryCancelButton = cancelButton;
                self.summaryDoneButton = doneButton;
                self.summaryCtid = ctid;
                self.summaryStartTime = startTime;
            }
        }];
    } else {
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView2.alpha = 0.5;
            summaryBackgroundView.frame = CGRectMake(20, 30, 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                self.summaryView = summaryBackgroundView;
                self.summaryTextView = textView;
                self.summaryCancelButton = cancelButton;
                self.summaryDoneButton = doneButton;
                self.summaryCtid = ctid;
                self.summaryStartTime = startTime;
            }
        }];
    }
    
    [textView becomeFirstResponder];
}

- (void)evaluationButtonPressed:(StreamEvaluationButton *)sender
{
    [self performSegueWithIdentifier:@"Stream Show Detail" sender:sender];
}

- (void)summaryButtonPressed:(StreamEvaluationButton *)sender
{
    [self displaySummaryWithCtid:sender.ctid andStartTime:sender.startTime];
}

- (IBAction)navButtonPressed:(UINavigationItem *)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)sendingButtonPressed:(UINavigationItem *)sender
{
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [self.view addSubview:self.blackView];
    
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hideButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [hideButton setTitle:@"" forState:UIControlStateNormal];
    hideButton.frame = self.view.frame;
    [self.blackView addSubview:hideButton];
    
    if (![[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"todayEventsArray"]] count]) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            self.popoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 310, 60)];
        } else {
            self.popoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 60, 310, 60)];
        }
    } else {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            self.popoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 310, 82 * [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"todayEventsArray"]] count] + 40)];
        } else {
            self.popoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 60, 310, 82 * [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"todayEventsArray"]] count] + 40)];
        }
    }
    self.popoverImageView.image = [[UIImage imageNamed:@"normal_popover"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 50, 50)];
    self.popoverImageView.alpha = 0;
    self.popoverImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.popoverImageView];
    
    if (![[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"todayEventsArray"]] count]) {
        NSLog(@"1");
        UILabel *noClassLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 22, 210, 21)];
        noClassLabel.text = @"今天竟然没有课...";
        noClassLabel.font = [UIFont systemFontOfSize:15.0];
        noClassLabel.textAlignment = NSTextAlignmentCenter;
        noClassLabel.textColor = [UIColor lightGrayColor];
        noClassLabel.backgroundColor = [UIColor clearColor];
        [self.popoverImageView addSubview:noClassLabel];
    } else {
        NSArray *todayEventsArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"todayEventsArray"]];
        for (int index = 0; index < [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"todayEventsArray"]] count]; index ++) {
            NSDictionary *todayEvent = [todayEventsArray objectAtIndex:index];
            
            NSInteger courseY = 0;
            if (index == 0) {
                courseY = 25;
            } else {
                courseY = 22 + (95 * index);
            }
            UILabel *courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, courseY, 120, 21)];
            courseNameLabel.text = [[todayEvent objectForKey:@"name"] description];
            courseNameLabel.font = [UIFont systemFontOfSize:15.0];
            courseNameLabel.backgroundColor = [UIColor clearColor];
            [self.popoverImageView addSubview:courseNameLabel];
            
            NSInteger timeY = 0;
            if (index == 0) {
                timeY = 50;
            } else {
                timeY = 46 + (95 * index);
            }
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, timeY, 120, 21)];
            timeLabel.text = [NSString stringWithFormat:@"%@ - %@", [[todayEvent objectForKey:@"startTime"] description], [[todayEvent objectForKey:@"endTime"] description]];
            timeLabel.font = [UIFont systemFontOfSize:13.0];
            timeLabel.textColor = [UIColor darkGrayColor];
            timeLabel.backgroundColor = [UIColor clearColor];
            [self.popoverImageView addSubview:timeLabel];
            
            NSInteger teacherY = 0;
            if (index == 0) {
                teacherY = 75;
            } else {
                teacherY = 70 + (95 * index);
            }
            UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, teacherY, 120, 21)];
            teacherLabel.text = [[todayEvent objectForKey:@"teacherName"] description];
            teacherLabel.font = [UIFont systemFontOfSize:15.0];
            teacherLabel.textColor = [UIColor darkGrayColor];
            teacherLabel.backgroundColor = [UIColor clearColor];
            [self.popoverImageView addSubview:teacherLabel];
            
            if (index + 1 != [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"todayEventsArray"]] count]) {
                NSInteger lineY = 0;
                if (index == 0) {
                    lineY = 107;
                } else {
                    lineY = 97 * (index + 1);
                }
                UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(6, lineY, 298, 1)];
                line.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1];
                [self.popoverImageView addSubview:line];
            }
            
            UIImage *starImage = [UIImage imageNamed:@"star_icon_blue"];
            UIImage *penImage = [UIImage imageNamed:@"pen_icon_blue"];
            UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(215, courseY + 6, starImage.size.width * 0.6, starImage.size.height * 0.6)];
            starImageView.image = starImage;
            UIImageView *penImageView = [[UIImageView alloc] initWithFrame:CGRectMake(215, teacherY - 3, penImage.size.width * 0.6, penImage.size.height * 0.6)];
            penImageView.image = penImage;
            [self.popoverImageView addSubview:starImageView];
            [self.popoverImageView addSubview:penImageView];
            
            StreamEvaluationButton *evaluationButton = [[StreamEvaluationButton alloc] initWithFrame:CGRectMake(230, courseY + 5, 80, starImage.size.height * 0.6)];
            [evaluationButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"小结" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:123.0/255.0 blue:243.0/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
            [evaluationButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"小结" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateHighlighted];
            [evaluationButton addTarget:self action:@selector(evaluationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            evaluationButton.courseName = [[todayEvent objectForKey:@"name"] description];
            evaluationButton.teacherName = [[todayEvent objectForKey:@"teacherName"] description];
            evaluationButton.courseProperty = [[todayEvent objectForKey:@"courseProperty"] description];
            evaluationButton.credit = [[todayEvent objectForKey:@"credit"] description];
            evaluationButton.ctid = [[todayEvent objectForKey:@"ctid"] description];
            evaluationButton.startTime = [[todayEvent objectForKey:@"startTime"] description];
            evaluationButton.endTime = [[todayEvent objectForKey:@"endTime"] description];
            
            StreamEvaluationButton *summaryButton = [[StreamEvaluationButton alloc] initWithFrame:CGRectMake(230, teacherY - 3, 80, penImage.size.height * 0.6)];
            [summaryButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"感受" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:123.0/255.0 blue:243.0/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:15.0]  }] forState:UIControlStateNormal];
            [summaryButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"感受" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:15.0]  }] forState:UIControlStateHighlighted];
            [summaryButton addTarget:self action:@selector(summaryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            summaryButton.ctid = [[todayEvent objectForKey:@"ctid"] description];
            summaryButton.startTime = [[todayEvent objectForKey:@"startTime"] description];
            
            [self.popoverImageView addSubview:evaluationButton];
            [self.popoverImageView addSubview:summaryButton];
        }
    }
    
    self.popoverImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.blackView.alpha = 0.5;
        self.popoverImageView.alpha = 1.0;
        self.popoverImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.popoverImageView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:nil];
        }
    }];
}

- (void)hideView
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.blackView.alpha = 0;
        self.popoverImageView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.blackView removeFromSuperview];
            [self.popoverImageView removeFromSuperview];
            self.blackView = nil;
            self.popoverImageView = nil;
        }
    }];
}

- (void)showErrorAlertUsingString:(NSString *)errorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Stream Show Detail"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
            if ([navigationController.topViewController isKindOfClass:[EvaluationTVC class]]) {
                EvaluationTVC *evaluationTVC = (EvaluationTVC *)navigationController.topViewController;
                StreamEvaluationButton *btn = sender;
                evaluationTVC.courseName = btn.courseName;
                evaluationTVC.teacherName = btn.teacherName;
                evaluationTVC.courseProperty = btn.courseProperty;
                evaluationTVC.credit = btn.credit;
                evaluationTVC.ctid = btn.ctid;
                evaluationTVC.startTime = btn.startTime;
                evaluationTVC.endTime = btn.endTime;
            }
        }
    }
}

#define UPDATE_LOGOUT_SEGUE_IDENTIFIER @"Update Logout"

- (void)logout
{
    // Clear NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    // Cancel local notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Clear cookie jar
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    // Delete Documents
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask] lastObject];
    NSURL *userUrl = [url URLByAppendingPathComponent:@"User Document"];
    NSURL *calendarUrl = [url URLByAppendingPathComponent:@"Calendar Document"];
    NSError *error;
    BOOL userFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[userUrl path]];
    BOOL calendarFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[calendarUrl path]];
    if (userFileExists)
    {
        BOOL userSuccess = [[NSFileManager defaultManager] removeItemAtPath:[userUrl path] error:&error];
        if (userSuccess) {
            if (calendarFileExists) {
                BOOL calendarSuccess = [[NSFileManager defaultManager] removeItemAtPath:[calendarUrl path] error:&error];
                if (calendarSuccess) {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogined"];
                    [self performSegueWithIdentifier:UPDATE_LOGOUT_SEGUE_IDENTIFIER sender:nil];
                } else if (!calendarSuccess) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogined"];
                [self performSegueWithIdentifier:UPDATE_LOGOUT_SEGUE_IDENTIFIER sender:nil];
            }
        } else if (!userSuccess) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    } else {
        if (calendarFileExists) {
            BOOL calendarSuccess = [[NSFileManager defaultManager] removeItemAtPath:[calendarUrl path] error:&error];
            if (calendarSuccess) {
                [self performSegueWithIdentifier:UPDATE_LOGOUT_SEGUE_IDENTIFIER sender:nil];
            } else if (!calendarSuccess) {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogined"];
            [self performSegueWithIdentifier:UPDATE_LOGOUT_SEGUE_IDENTIFIER sender:nil];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] isEqualToString:@"2017"]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce_0.9_01"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"本次更新需要重新登录:)"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [self logout];
        }
    }
    if ([(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] isEqualToString:@"2187"]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce_0.9.1"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GPAGeniusSwitch"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce_0.9.1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#define NAVIGATION_VIEW_CONTROLLER_IDENTIFIER @"Navigation"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Edit slide menu's shadow
    self.view.layer.shadowOpacity = 0.25f;
    self.view.layer.shadowRadius = 2.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    // Instantiate navigation view controller
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[NavigationViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:NAVIGATION_VIEW_CONTROLLER_IDENTIFIER];
    }
    
    // Add pan gesture
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateComponents *comps = [CalendarCalculator getDateComps];
    
    self.numberOfWeekInTheSemester = [self.calendarCalculator whichWeekOfTheSemester:[NSString stringWithFormat:@"%d-%d-%d", comps.year, comps.month, comps.day]];
    
    NSInteger week = [self.calendarCalculator whichWeekByAGivenDay:comps.day month:comps.month year:comps.year] - 1;
    if (week == -1) {
        week = 6;
    } else if (week == 0) {
        week = 7;
    }
    self.dayOfTheWeek = week;
    
    if (self.numberOfWeekInTheSemester % 2 == 1) {
        self.weekProperty = @"单";
    } else if (self.numberOfWeekInTheSemester % 2 == 0) {
        self.weekProperty = @"双";
    }
    
    UIImage *barButtonImage = [UIImage imageNamed:@"toolbar_nav_icon"];
    UIBarButtonItem *nav = [[UIBarButtonItem alloc] init];
    nav = [UIBarButtonItem barItemWithImage:barButtonImage
                                     target:self
                                     action:@selector(navButtonPressed:)
                                 edgeInsets:UIEdgeInsetsZero
                                      width:barButtonImage.size.width
                                     height:barButtonImage.size.height];
    self.topViewController.navigationItem.leftBarButtonItem = nav;
    
    UIImage *barButtonImage2 = [UIImage imageNamed:@"toolbar_sending_icon"];
    UIBarButtonItem *sending = [[UIBarButtonItem alloc] init];
    sending = [UIBarButtonItem barItemWithImage:barButtonImage2
                                         target:self
                                         action:@selector(sendingButtonPressed:)
                                     edgeInsets:UIEdgeInsetsZero
                                          width:barButtonImage2.size.width
                                         height:barButtonImage2.size.height];
    self.topViewController.navigationItem.rightBarButtonItem = sending;
    
    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        self.navigationBar.titleTextAttributes = @{ UITextAttributeFont : [UIFont systemFontOfSize:17.0], UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero] };
    }
    
    self.managedObjectContext = self.managedDocumentHandlerDelegate.calendarDocument.managedObjectContext;
}

@end
