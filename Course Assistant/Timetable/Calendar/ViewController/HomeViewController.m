//
//  HomeViewController.m
//  南工课立方
//
//  Created by Jason J on 13-5-8.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CalendarViewController.h"
#import "CalendarListViewController.h"
#import "ECSlidingViewController.h"
#import "NavigationViewController.h"
#import "CalendarToolbar.h"
#import "UIBarButtonItem+Custom.h"
#import "EvaluationTextView.h"

@interface HomeViewController () <CalendarViewControllerDelegate, CalendarListViewControllerDelegate, UIToolbarDelegate, ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIView *datePickerContainerView;
@property (weak, nonatomic) IBOutlet UIView *calendarContainerView;
@property (weak, nonatomic) IBOutlet UIView *calendarListContainerView;
@property (weak, nonatomic) IBOutlet CalendarToolbar *calendarToolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *utilityToolbar;
@property (weak, nonatomic) IBOutlet UILabel *yearMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (strong, nonatomic) CalendarViewController *calendarVC;
@property (strong, nonatomic) CalendarListViewController *calendarListVC;
@property (strong, nonatomic) UIView *summaryView;
@property (strong, nonatomic) UIView *blackView;
@property (strong, nonatomic) UITextView *summaryTextView;
@property (strong, nonatomic) UIButton *summaryCancelButton;
@property (strong, nonatomic) UIButton *summaryDoneButton;
@property (strong, nonatomic) NSString *summaryCtid;
@property (strong, nonatomic) NSString *summaryStartTime;
@end

@implementation HomeViewController

@synthesize year = _year;
@synthesize month = _month;

- (CalendarViewController *)calendarVC
{
    if (!_calendarVC) {
        _calendarVC = [[CalendarViewController alloc] init];
    }
    return _calendarVC;
}

- (CalendarListViewController *)calendarListVC
{
    if (!_calendarListVC) {
        _calendarListVC = [[CalendarListViewController alloc] init];
    }
    return _calendarListVC;
}

// Navigation button pressed
- (IBAction)navButtonPressed:(UIBarButtonItem *)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

// Add button pressed
- (IBAction)addButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"Add Event" sender:nil];
}

// Date button pressed
- (IBAction)dateButtonPressed:(UIBarButtonItem *)sender
{
    if (self.datePickerContainerView.hidden) {
        self.datePickerContainerView.hidden = NO;
    } else {
        [self cancelPick];
    }
}

// Today button pressed
- (IBAction)todayPressed
{
    [self.calendarListVC performToday];
    [self.calendarVC resetToday];
}

- (void)updateToday
{
    [self.calendarListVC performToday];
    [self.calendarVC resetToday];
}

/*
- (void)rotateUpdateIcon
{
    CGAffineTransform transform = self.updateIcon.transform;
    if (CGAffineTransformIsIdentity(transform)) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.updateIcon.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 1.0, 1.0), 2*M_PI/3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.updateIcon.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 1.0, 1.0), -2*M_PI/3);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.updateIcon.transform = CGAffineTransformScale(transform, 1.0, 1.0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
}
*/

- (void)calendarViewController:(CalendarViewController *)sender didUpdateYearAndMonth:(NSString *)yearMonth
{
    self.yearMonthLabel.text = yearMonth;
}

- (void)calendarListViewController:(CalendarListViewController *)sender didUpdateYearAndMonth:(NSString *)yearMonth
{
    self.yearMonthLabel.text = yearMonth;
}

#define PLACEHOLDER @"觉得今天的课上的怎样？还有哪些地方需要改进？把你的想法告诉老师吧！（200字以内）"

- (void)displaySummaryWithCtid:(NSString *)ctid andStartTime:(NSString *)startTime
{
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0;
    [self.view addSubview:blackView];
    self.blackView = blackView;
    
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
            blackView.alpha = 0.5;
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
            blackView.alpha = 0.5;
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
        if ([[result valueForKey:@"msg"] isEqualToString:@"succeed"]) {
            [self showErrorAlertUsingString:@"发布成功"];
        } else {
            [self showErrorAlertUsingString:[result valueForKey:@"msg"]];
        }
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
    
    NSLog(POST_SUMMARY_FORMAT, schoolnumber, ctid, content, startTime);
    
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

- (void)removeSummaryViewToSend
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView.alpha = 0;
            self.summaryView.frame = CGRectMake(20, -(self.view.frame.size.height - 252 - 40), 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.summaryView removeFromSuperview];
                [self.blackView removeFromSuperview];
                self.summaryView = nil;
                self.blackView = nil;
            }
        }];
    } else {
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView.alpha = 0;
            self.summaryView.frame = CGRectMake(20, -(self.view.frame.size.height - 252 - 40), 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.summaryView removeFromSuperview];
                [self.blackView removeFromSuperview];
                self.summaryView = nil;
                self.blackView = nil;
            }
        }];
    }
    
    [self.summaryTextView resignFirstResponder];
    self.summaryTextView = nil;
}

- (void)removeSummaryView
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView.alpha = 0;
            self.summaryView.frame = CGRectMake(20, self.view.frame.size.height, 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.summaryView removeFromSuperview];
                [self.blackView removeFromSuperview];
                self.summaryView = nil;
                self.blackView = nil;
            }
        }];
    } else {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blackView.alpha = 0;
            self.summaryView.frame = CGRectMake(20, self.view.frame.size.height, 280, self.view.frame.size.height - 252 - 40);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.summaryView removeFromSuperview];
                [self.blackView removeFromSuperview];
                self.summaryView = nil;
                self.blackView = nil;
            }
        }];
    }
    
    [self.summaryTextView resignFirstResponder];
    self.summaryTextView = nil;
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

- (void)cancelPick
{
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickerContainerView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.datePickerContainerView.alpha = 1;
            self.datePickerContainerView.hidden = YES;
        }
    }];
}

- (void)donePickWithYear:(NSInteger)year andMonth:(NSInteger)month
{
    [self.calendarVC selectDateWithYear:year andMonth:month];
    [self cancelPick];
}

- (void)preMonth
{
    [self.calendarVC preMonthPressed];
}

- (void)nextMonth
{
    [self.calendarVC nextMonthPressed];
}

- (void)segmentChanged:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    
    if (index) {
        self.calendarListContainerView.hidden = YES;
        self.calendarContainerView.hidden = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"calendarOption"];
        self.yearMonthLabel.text = [NSString stringWithFormat:@"%d 年 %d 月", self.calendarVC.year, self.calendarVC.month];
        [self setToolbarButtonsWithOption:1];
    } else {
        self.calendarListContainerView.hidden = NO;
        self.calendarContainerView.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"calendarOption"];
        [self setToolbarButtonsWithOption:0];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Calendar"]) {
        if ([segue.destinationViewController isKindOfClass:[CalendarViewController class]]) {
            self.calendarVC = segue.destinationViewController;
            self.calendarVC.delegate = self;
        }
    } else if ([segue.identifier isEqualToString:@"Embed Calendar List"]) {
        if ([segue.destinationViewController isKindOfClass:[CalendarListViewController class]]) {
            self.calendarListVC = segue.destinationViewController;
            self.calendarListVC.delegate = self;
        }
    }
}

- (void)setToolbarButtonsWithOption:(NSInteger)option
{
    // Set button items on toolbar - top
    UIImage *navBarButtonImage = [UIImage imageNamed:@"toolbar_nav_icon.png"];
    //UIImage *addBarButtonImage = [UIImage imageNamed:@"toolbar_add_icon.png"];
    UIBarButtonItem *nav = [[UIBarButtonItem alloc] init];
    nav = [UIBarButtonItem barItemWithImage:navBarButtonImage
                                     target:self
                                     action:@selector(navButtonPressed:)
                                 edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                      width:navBarButtonImage.size.width
                                     height:navBarButtonImage.size.height];
    /*
    UIBarButtonItem *add = [[UIBarButtonItem alloc] init];
    add = [UIBarButtonItem barItemWithImage:addBarButtonImage
                                     target:self
                                     action:@selector(addButtonPressed:)
                                 edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                      width:addBarButtonImage.size.width
                                     height:addBarButtonImage.size.height
                           highlightedImage:addBarButtonHighlightedImage];
    */
    UIBarButtonItem *measurement = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    if (option == 0) {
        self.calendarToolbar.items = [NSArray arrayWithObjects:nav, measurement, nil];
    } else if (option == 1) {
        UIImage *leftChevronImage = [UIImage imageNamed:@"chevron_left.png"];
        UIImage *rightChevronImage = [UIImage imageNamed:@"chevron_right.png"];
        UIImage *leftChevronHighlightedImage = [UIImage imageNamed:@"chevron_left_highlighted.png"];
        UIImage *rightChevronHighlightedImage = [UIImage imageNamed:@"chevron_right_highlighted.png"];
        UIBarButtonItem *leftChevron = [[UIBarButtonItem alloc] init];
        UIBarButtonItem *rightChevron = [[UIBarButtonItem alloc] init];
        
        rightChevron = [UIBarButtonItem barItemWithImage:rightChevronImage
                                                  target:self
                                                  action:@selector(nextMonth)
                                              edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                   width:rightChevronImage.size.width
                                                  height:rightChevronImage.size.height
                                        highlightedImage:rightChevronHighlightedImage];
        leftChevron = [UIBarButtonItem barItemWithImage:leftChevronImage
                                                 target:self
                                                 action:@selector(preMonth)
                                             edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                  width:leftChevronImage.size.width
                                                 height:leftChevronImage.size.height
                                       highlightedImage:leftChevronHighlightedImage];
        
        UIBarButtonItem *measurementA = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            measurementA.width = 5;
        } else {
            measurementA.width = 0;
        }
        
        UIBarButtonItem *measurementB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        measurementB.width = 122;
        self.calendarToolbar.items = [NSArray arrayWithObjects:nav, measurementA, leftChevron, measurementB, rightChevron, nil];
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

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"calendarOption"]) {
        self.calendarContainerView.hidden = YES;
        self.calendarListContainerView.hidden = NO;
    } else {
        self.calendarContainerView.hidden = NO;
        self.calendarListContainerView.hidden = YES;
    }
    
    self.calendarToolbar.delegate = self;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [self.utilityToolbar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg_ios6"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        self.utilityToolbar.barTintColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        self.utilityToolbar.translucent = NO;
    }
    
    // Set button items on toolbar - bottom
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] init];
    todayButton.target = self;
    todayButton.action = @selector(todayPressed);
    todayButton.title = @"今天";
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [todayButton setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeFont : [UIFont systemFontOfSize:17.0] } forState:UIControlStateNormal];
    } else {
        todayButton.tintColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1];
    }
    
    UIBarButtonItem *measurementA = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *measurementB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UISegmentedControl *switcher = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"周", @"月", nil]];
    [switcher setFrame:CGRectMake(0, 0, 160, 28)];
    [switcher setSegmentedControlStyle:UISegmentedControlStyleBar];
    if (!self.calendarContainerView.hidden) {
        [switcher setSelectedSegmentIndex:1];
        [self setToolbarButtonsWithOption:1];
    } else {
        [switcher setSelectedSegmentIndex:0];
        [self setToolbarButtonsWithOption:0];
    }
    [switcher addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [switcher setBackgroundImage:[[UIImage imageNamed:@"control_toolbar_item_icon.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [switcher setBackgroundImage:[[UIImage imageNamed:@"control_toolbar_item_icon_highlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [switcher setDividerImage:[UIImage imageNamed:@"segmented_control_divider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [switcher setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] } forState:UIControlStateNormal];
        [switcher setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] } forState:UIControlStateSelected];
    } else {
        switcher.tintColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1];
    }
    UIBarButtonItem *segmentItem = [[UIBarButtonItem alloc] initWithCustomView:switcher];
    self.utilityToolbar.items = [NSArray arrayWithObjects:todayButton, measurementA, segmentItem, measurementB, nil];
}

@end
