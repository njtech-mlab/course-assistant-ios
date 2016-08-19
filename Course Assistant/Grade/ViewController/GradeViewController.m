//
//  GradeViewController.m
//  南工课立方
//
//  Created by Jason J on 13-5-16.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "GradeViewController.h"
#import "ECSlidingViewController.h"
#import "NavigationViewController.h"
#import "GradeDatePickerViewController.h"
#import "GradeTVC.h"
#import "UIBarButtonItem+Custom.h"
#import "CalendarToolbar.h"
#import "CommonFetch.h"

@interface GradeViewController () <GradeDatePickerViewControllerDelegate, GradeTVCDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIToolbarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pointerImageView;
@property (weak, nonatomic) IBOutlet CalendarToolbar *calendarToolbar;
@property (weak, nonatomic) IBOutlet UIView *gradeDatePickerContainerView;
@property (weak, nonatomic) IBOutlet UIView *gradeContainerView;
@property (strong, nonatomic) GradeDatePickerViewController *gradeDatePickerVC;
@property (strong, nonatomic) GradeTVC *gradeTVC;
@property (strong, nonatomic) UIBarButtonItem *dateBarButtonItem;
@property (strong, nonatomic) NSMutableData *mutableData;
@property (strong, nonatomic) NSString *postString;
@property (strong, nonatomic) UIView *loadingView;
@end

@implementation GradeViewController

- (NSMutableData *)mutableData
{
    if (!_mutableData) {
        _mutableData = [[NSMutableData alloc] init];
    }
    return _mutableData;
}

- (GradeTVC *)gradeTVC
{
    if (!_gradeTVC) {
        _gradeTVC = [[GradeTVC alloc] init];
    }
    return _gradeTVC;
}

- (GradeDatePickerViewController *)gradeDatePickerVC
{
    if (!_gradeDatePickerVC) {
        _gradeDatePickerVC = [[GradeDatePickerViewController alloc] init];
    }
    return _gradeDatePickerVC;
}

- (void)cancelPick
{
    if (self.pointerImageView.hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                self.gradeDatePickerContainerView.frame = CGRectMake(0, 44, 320, 0);
                self.gradeContainerView.frame = CGRectMake(0, 44, 320, self.gradeContainerView.frame.size.height);
            } else {
                self.gradeDatePickerContainerView.frame = CGRectMake(0, 64, 320, 0);
                self.gradeContainerView.frame = CGRectMake(0, 64, 320, self.gradeContainerView.frame.size.height);
            }
            self.gradeDatePickerContainerView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.gradeDatePickerContainerView.hidden = YES;
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                self.gradeDatePickerContainerView.frame = CGRectMake(0, 44, 320, 0);
                self.gradeContainerView.frame = CGRectMake(0, 44, 320, self.gradeContainerView.frame.size.height);
                self.pointerImageView.frame = CGRectMake(0, 44, 320, self.pointerImageView.frame.size.height);
            } else {
                self.gradeDatePickerContainerView.frame = CGRectMake(0, 64, 320, 0);
                self.gradeContainerView.frame = CGRectMake(0, 64, 320, self.gradeContainerView.frame.size.height);
                self.pointerImageView.frame = CGRectMake(0, 64, 320, self.pointerImageView.frame.size.height);
            }
            self.gradeDatePickerContainerView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.gradeDatePickerContainerView.hidden = YES;
            }
        }];
    }
}

- (void)gradeTVCDidRefresh:(GradeTVC *)sender
{
    NSLog(@"%@", self.postString);
    [self startConnectingWithPostString:self.postString];
}

#define POST_GRADE_STRING_FORMAT @"year=%@&term=%@&schoolnumber=%@"
#define POST_GRADE_STRING_FORMAT_ALL @"schoolnumber=%@"
#define POST_GRADE_STRING_FORMAT_YEAR @"year=%@&schoolnumber=%@"
#define POST_GRADE_STRING_FORMAT_TERM @"term=%@&schoolnumber=%@"

- (void)donePickWithYear:(NSString *)year andSemester:(NSInteger)semester
{
    self.pointerImageView.hidden = YES;
    self.gradeTVC.view.hidden = NO;
    NSString *semesterString;
    if (semester == 1) {
        semesterString = @"第一学期";
    } else if (semester == 2) {
        semesterString = @"第二学期";
    } else if (semester == 3) {
        semesterString = @"所有学期";
    } else if (semester == 0) {
        semesterString = @"所有学期";
        semester = 3;
    }
    if (!year) {
        year = @"所有学年";
    }
    UIFont *dateFont = [UIFont systemFontOfSize:17.0];
    [self.dateBarButtonItem setTitleTextAttributes:@{ UITextAttributeFont : dateFont, UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] } forState:UIControlStateNormal];
    self.dateBarButtonItem.title = [NSString stringWithFormat:@"%@/%@", year, semesterString];
    if (semester == 3 && [year isEqualToString:@"所有学年"]) {
        self.postString = [NSString stringWithFormat:POST_GRADE_STRING_FORMAT_ALL, [[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"]];
    } else if (semester == 3 && ![year isEqualToString:@"所有学年"]) {
        self.postString = [NSString stringWithFormat:POST_GRADE_STRING_FORMAT_YEAR, year, [[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"]];
    } else if ([year isEqualToString:@"所有学年"] && semester != 3) {
        self.postString = [NSString stringWithFormat:POST_GRADE_STRING_FORMAT_TERM, [NSString stringWithFormat:@"%d", semester], [[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"]];
    } else {
        self.postString = [NSString stringWithFormat:POST_GRADE_STRING_FORMAT, year, [NSString stringWithFormat:@"%d", semester], [[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"]];
    }
    [self cancelPick];
    [self startConnectingWithPostString:self.postString];
    [self animateLoadingView];
}

- (void)switchNetworkActivityIndicatorVisibleTo:(BOOL)boolean
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = boolean;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    [self showErrorAlertUsingString:@"获取失败，请重试。"];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    NSLog(@"%@", error.localizedDescription);
    [self invalidateLoadingView];
    [connection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.gradeTVC.scoreArray = [CommonFetch fetchData:self.mutableData];
    self.mutableData = nil;
    [self.gradeTVC.refreshControl endRefreshing];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    [self invalidateLoadingView];
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data) {
        [self.mutableData appendData:data];
    } else {
        [connection cancel];
        [self showErrorAlertUsingString:@"获取失败，请重试。"];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
    }
}

#define SCORE_URL @"http://app.njut.org.cn/timetable/fetchscore.action"
#define ALL_SCORE_URL @"http://app.njut.org.cn/timetable/allscore.action"
#define ALL_YEAR_SCORE_URL @"http://app.njut.org.cn/timetable/allyearscore.action"
#define ALL_TERM_SCORE_URL @"http://app.njut.org.cn/timetable/alltermscore.action"

- (void)startConnectingWithPostString:(NSString *)postString
{
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if ([postString rangeOfString:@"year="].location == NSNotFound && [postString rangeOfString:@"term="].location == NSNotFound) {
        [request setURL:[NSURL URLWithString:ALL_SCORE_URL]];
    } else if ([postString rangeOfString:@"term="].location == NSNotFound) {
        [request setURL:[NSURL URLWithString:ALL_YEAR_SCORE_URL]];
    } else if ([postString rangeOfString:@"year="].location == NSNotFound) {
        [request setURL:[NSURL URLWithString:ALL_TERM_SCORE_URL]];
    } else {
        [request setURL:[NSURL URLWithString:SCORE_URL]];
    }
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 20;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self switchNetworkActivityIndicatorVisibleTo:YES];
    [conn start];
}

- (void)showErrorAlertUsingString:(NSString *)errorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [self invalidateLoadingView];
    [alert show];
}

- (void)connectionOvertime:(NSTimer *)timer
{
    [(NSURLConnection *)[timer userInfo] cancel];
    [self showErrorAlertUsingString:@"获取失败，请检查网络。"];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
}

- (void)animateLoadingView
{
    self.dateBarButtonItem.enabled = NO;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)];
    } else {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64)];
    }
    self.loadingView.backgroundColor = [UIColor colorWithRed:139.0/255.0 green:149.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.loadingView.alpha = 0;
    [self.view addSubview:self.loadingView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loadingView.alpha = 1;
    } completion:nil];
}

- (void)invalidateLoadingView
{
    self.dateBarButtonItem.enabled = YES;
    [self.view addSubview:self.loadingView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.loadingView removeFromSuperview];
        }
    }];
}

- (IBAction)navButtonPressed:(UIBarButtonItem *)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)showDatePicker:(UIBarButtonItem *)sender
{
    if (self.gradeDatePickerContainerView.hidden) {
        if (self.pointerImageView.hidden) {
            self.gradeDatePickerContainerView.hidden = NO;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                self.gradeDatePickerContainerView.frame = CGRectMake(0, 44, 320, 0);
            } else {
                self.gradeDatePickerContainerView.frame = CGRectMake(0, 64, 320, 0);
            }
            self.gradeDatePickerContainerView.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                    self.gradeDatePickerContainerView.frame = CGRectMake(0, 44, 320, 250);
                } else {
                    self.gradeDatePickerContainerView.frame = CGRectMake(0, 64, 320, 250);
                }
                self.gradeDatePickerContainerView.alpha = 1;
                if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                    self.gradeContainerView.frame = CGRectMake(0, 294, 320, self.gradeContainerView.frame.size.height);
                } else {
                    self.gradeContainerView.frame = CGRectMake(0, 314, 320, self.gradeContainerView.frame.size.height);
                }
            } completion:nil];
        } else {
            self.gradeDatePickerContainerView.hidden = NO;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                self.gradeDatePickerContainerView.frame = CGRectMake(0, 44, 320, 0);
            } else {
                self.gradeDatePickerContainerView.frame = CGRectMake(0, 64, 320, 0);
            }
            self.gradeDatePickerContainerView.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                    self.gradeDatePickerContainerView.frame = CGRectMake(0, 44, 320, 250);
                } else {
                    self.gradeDatePickerContainerView.frame = CGRectMake(0, 64, 320, 250);
                }
                self.gradeDatePickerContainerView.alpha = 1;
                if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                    self.pointerImageView.frame = CGRectMake(0, 294, 320, self.pointerImageView.frame.size.height);
                    self.gradeContainerView.frame = CGRectMake(0, 294, 320, self.gradeContainerView.frame.size.height);
                } else {
                    self.pointerImageView.frame = CGRectMake(0, 314, 320, self.pointerImageView.frame.size.height);
                    self.gradeContainerView.frame = CGRectMake(0, 314, 320, self.gradeContainerView.frame.size.height);
                }
            } completion:nil];
        }
    } else {
        [self cancelPick];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Grade Date Picker"]) {
        if ([segue.destinationViewController isKindOfClass:[GradeDatePickerViewController class]]) {
            self.gradeDatePickerVC = segue.destinationViewController;
            self.gradeDatePickerVC.delegate = self;
        }
    } else if ([segue.identifier isEqualToString:@"Embed Grade Table"]) {
        if ([segue.destinationViewController isKindOfClass:[GradeTVC class]]) {
            self.gradeTVC = segue.destinationViewController;
            self.gradeTVC.delegate = self;
        }
    }
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#define NAVIGATION_VIEW_CONTROLLER_IDENTIFIER @"Navigation"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.gradeTVC.view.hidden = YES;
    
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
    
    self.calendarToolbar.delegate = self;
        
    UIImage *navBarButtonImage = [UIImage imageNamed:@"toolbar_nav_icon.png"];
    UIBarButtonItem *nav = [[UIBarButtonItem alloc] init];
    UIBarButtonItem *date = [[UIBarButtonItem alloc] init];
    nav = [UIBarButtonItem barItemWithImage:navBarButtonImage
                                     target:self
                                     action:@selector(navButtonPressed:)
                                 edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                      width:navBarButtonImage.size.width
                                     height:navBarButtonImage.size.height];
    date.style = UIBarButtonItemStylePlain;
    date.target = self;
    date.action = @selector(showDatePicker:);
    date.title = @"学年/学期";
    date.tintColor = [UIColor whiteColor];
    UIFont *dateFont = [UIFont systemFontOfSize:17.0];
    [date setTitleTextAttributes:@{ UITextAttributeFont : dateFont, UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] } forState:UIControlStateNormal];
    
    date.width = 160.0;
    self.dateBarButtonItem = date;
    UIBarButtonItem *measurementA = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *measurementB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.calendarToolbar.items = [NSArray arrayWithObjects:nav, measurementA, date, measurementB, nil];
}

@end
