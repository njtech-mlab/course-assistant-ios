//
//  EvaluationTVC.m
//  南工评教
//
//  Created by Jason J on 13-5-2.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "EvaluationTVC.h"
#import "EvaluationTextView.h"
#import "DLStarRatingControl.h"
#import "DAKeyboardControl.h"
#import "UIBarButtonItem+Custom.h"

@interface EvaluationTVC () <DLStarRatingDelegate, UITextViewDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *courseImageCell;
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *evaluationGrid;
@property (weak, nonatomic) IBOutlet UITableViewCell *effectCell;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coursePropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (strong, nonatomic) UIButton *disciplineBtn1;
@property (strong, nonatomic) UIButton *disciplineBtn2;
@property (strong, nonatomic) UIButton *disciplineBtn3;
@property (strong, nonatomic) UIButton *attendanceBtn1;
@property (strong, nonatomic) UIButton *attendanceBtn2;
@property (strong, nonatomic) UIButton *attendanceBtn3;
@property (strong, nonatomic) UIButton *speedBtn1;
@property (strong, nonatomic) UIButton *speedBtn2;
@property (strong, nonatomic) UIButton *speedBtn3;
@property (strong, nonatomic) UILabel *surveyTitleLabel;
@property (strong, nonatomic) UIImageView *sepImageView2;
@property (strong, nonatomic) UIImageView *sepImageView3;
@property (strong, nonatomic) EvaluationTextView *adviceTextView;
@property (nonatomic) CGRect ornamentRect;
@property (nonatomic) NSInteger overallRating;
@property (nonatomic) NSInteger disciplineRating;
@property (nonatomic) NSInteger attendanceRating;
@property (nonatomic) NSInteger speedRating;
@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) NSString *evaluationInfo;
@property (strong, nonatomic) DLStarRatingControl *starControl;
@property (strong, nonatomic) UILabel *anonymityLabel;
@property (strong, nonatomic) UILabel *planLabel;
@property (strong, nonatomic) UILabel *attendanceLabel;
@property (strong, nonatomic) UILabel *speedLabel;
@end

@implementation EvaluationTVC

#define OPTION_BUTTON_ALPHA 0.5

- (IBAction)speedBtn3Pressed:(UIButton *)sender
{
    self.speedRating = 5;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.speedRating = 0;
    }
    self.speedBtn1.selected = NO;
    self.speedBtn2.selected = NO;
}

- (IBAction)speedBtn2Pressed:(UIButton *)sender
{
    self.speedRating = 3;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.speedRating = 0;
    }
    self.speedBtn1.selected = NO;
    self.speedBtn3.selected = NO;
}

- (IBAction)speedBtn1Pressed:(UIButton *)sender
{
    self.speedRating = 1;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.speedRating = 0;
    }
    self.speedBtn2.selected = NO;
    self.speedBtn3.selected = NO;
}

- (IBAction)attendanceBtn3Pressed:(UIButton *)sender
{
    [self.adviceTextView resignFirstResponder];
    self.attendanceRating = 5;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.attendanceRating = 0;
    }
    self.attendanceBtn1.selected = NO;
    self.attendanceBtn2.selected = NO;
}

- (IBAction)attendanceBtn2Pressed:(UIButton *)sender
{
    [self.adviceTextView resignFirstResponder];
    self.attendanceRating = 3;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.attendanceRating = 0;
    }
    self.attendanceBtn1.selected = NO;
    self.attendanceBtn3.selected = NO;
}

- (IBAction)attendanceBtn1Pressed:(UIButton *)sender
{
    [self.adviceTextView resignFirstResponder];
    self.attendanceRating = 1;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.attendanceRating = 0;
    }
    self.attendanceBtn2.selected = NO;
    self.attendanceBtn3.selected = NO;
}

- (IBAction)disciplineBtn3Pressed:(UIButton *)sender
{
    [self.adviceTextView resignFirstResponder];
    self.disciplineRating = 5;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.disciplineRating = 0;
    }
    self.disciplineBtn1.selected = NO;
    self.disciplineBtn2.selected = NO;
    
    self.attendanceBtn1.alpha = 0.6;
    self.attendanceBtn1.enabled = NO;
    self.attendanceBtn1.selected = NO;
    self.attendanceBtn2.alpha = 0.6;
    self.attendanceBtn2.enabled = NO;
    self.attendanceBtn2.selected = NO;
    self.attendanceBtn3.alpha = 0.6;
    self.attendanceBtn3.enabled = NO;
    self.attendanceBtn3.selected = NO;
    self.speedBtn1.alpha = 0.6;
    self.speedBtn1.enabled = NO;
    self.speedBtn1.selected = NO;
    self.speedBtn2.alpha = 0.6;
    self.speedBtn2.enabled = NO;
    self.speedBtn2.selected = NO;
    self.speedBtn3.alpha = 0.6;
    self.speedBtn3.enabled = NO;
    self.speedBtn3.selected = NO;
    
    self.attendanceRating = 0;
    self.speedRating = 0;
    
    self.starControl.enabled = NO;
    self.starControl.alpha = 0.5;
    
    self.adviceTextView.editable = NO;
    self.adviceTextView.alpha = 0.5;
}

- (IBAction)disciplineBtn2Pressed:(UIButton *)sender
{
    [self.adviceTextView resignFirstResponder];
    self.disciplineRating = 3;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.disciplineRating = 0;
    }
    self.disciplineBtn1.selected = NO;
    self.disciplineBtn3.selected = NO;
    
    self.attendanceBtn1.alpha = 0.6;
    self.attendanceBtn1.enabled = NO;
    self.attendanceBtn1.selected = NO;
    self.attendanceBtn2.alpha = 0.6;
    self.attendanceBtn2.enabled = NO;
    self.attendanceBtn2.selected = NO;
    self.attendanceBtn3.alpha = 0.6;
    self.attendanceBtn3.enabled = NO;
    self.attendanceBtn3.selected = NO;
    self.speedBtn1.alpha = 0.6;
    self.speedBtn1.enabled = NO;
    self.speedBtn1.selected = NO;
    self.speedBtn2.alpha = 0.6;
    self.speedBtn2.enabled = NO;
    self.speedBtn2.selected = NO;
    self.speedBtn3.alpha = 0.6;
    self.speedBtn3.enabled = NO;
    self.speedBtn3.selected = NO;
    
    self.attendanceRating = 0;
    self.speedRating = 0;
    
    self.starControl.enabled = NO;
    self.starControl.alpha = 0.5;
    
    self.adviceTextView.editable = NO;
    self.adviceTextView.alpha = 0.5;
}

- (IBAction)disciplineBtn1Pressed:(UIButton *)sender
{
    [self.adviceTextView resignFirstResponder];
    self.disciplineRating = 1;
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.disciplineRating = 0;
    }
    self.disciplineBtn2.selected = NO;
    self.disciplineBtn3.selected = NO;
    
    self.attendanceBtn1.alpha = 1;
    self.attendanceBtn1.enabled = YES;
    self.attendanceBtn2.alpha = 1;
    self.attendanceBtn2.enabled = YES;
    self.attendanceBtn3.alpha = 1;
    self.attendanceBtn3.enabled = YES;
    self.speedBtn1.alpha = 1;
    self.speedBtn1.enabled = YES;
    self.speedBtn2.alpha = 1;
    self.speedBtn2.enabled = YES;
    self.speedBtn3.alpha = 1;
    self.speedBtn3.enabled = YES;
    
    self.starControl.enabled = YES;
    self.starControl.alpha = 1;
    
    self.adviceTextView.editable = YES;
    self.adviceTextView.alpha = 1;
}

- (void)newRating:(DLStarRatingControl *)control :(float)rating
{
    NSInteger numberOfStar = [[NSNumber numberWithFloat:rating] integerValue];
    NSInteger ratingValue;
    NSString *effectString;
    switch (numberOfStar) {
        case 1:
            ratingValue = 1;
            effectString = @"很差";
            break;
        case 2:
            ratingValue = 2;
            effectString = @"较差";
            break;
        case 3:
            ratingValue = 3;
            effectString = @"一般";
            break;
        case 4:
            ratingValue = 4;
            effectString = @"较好";
            break;
        case 5:
            ratingValue = 5;
            effectString = @"很好";
            break;
        default:
            ratingValue = 0;
            effectString = @"";
            break;
    }
    self.overallRating = ratingValue;
    self.effectLabel.text = effectString;
    
    if (!self.adviceTextView) {
        [self initAdviceTextView];
    } else {
        if (ratingValue >= 3) {
            self.adviceTextView.backgroundColor = [UIColor colorWithRed:45.0/255.0 green:200.0/255.0 blue:110.0/255.0 alpha:1];
            [self.starControl setStar:[UIImage imageNamed:@"star"] highlightedStar:[UIImage imageNamed:@"star_highlighted"] atIndex:0];
            [self.starControl setStar:[UIImage imageNamed:@"star"] highlightedStar:[UIImage imageNamed:@"star_highlighted"] atIndex:1];
        } else {
            self.adviceTextView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1];
            [self.starControl setStar:[UIImage imageNamed:@"star"] highlightedStar:[UIImage imageNamed:@"star_red_highlighted"] atIndex:0];
            [self.starControl setStar:[UIImage imageNamed:@"star"] highlightedStar:[UIImage imageNamed:@"star_red_highlighted"] atIndex:1];
        }
        [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.adviceTextView.frame = CGRectMake(15, 270, 290, 110);
        } completion:^(BOOL finished) {
            if (finished) {
                if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.adviceTextView.frame = CGRectMake(20, 275, 280, 100);
                    } completion:nil];
                } else {
                    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.adviceTextView.frame = CGRectMake(20, 275, 280, 100);
                    } completion:nil];
                }
            }
        }];
    }
}

#define PLACEHOLDER @"今天课上学到了什么？还有什么问题和疑惑？和老师同学一起交流讨论吧！（200字以内）"
#define FONT_SIZE 15.0

- (void)initAdviceTextView
{
    self.adviceTextView = [[EvaluationTextView alloc] init];
    self.adviceTextView.delegate = self;
    self.adviceTextView.placeholder = PLACEHOLDER;
    self.adviceTextView.placeholderColor = [UIColor whiteColor];
    self.adviceTextView.textColor = [UIColor whiteColor];
    self.adviceTextView.font = [UIFont systemFontOfSize:FONT_SIZE];
    //self.adviceTextView.layer.borderColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1].CGColor;
    self.adviceTextView.layer.borderColor = [UIColor clearColor].CGColor;
    if (self.overallRating >= 3) {
        self.adviceTextView.backgroundColor = [UIColor colorWithRed:45.0/255.0 green:200.0/255.0 blue:110.0/255.0 alpha:1];
        [self.starControl setStar:[UIImage imageNamed:@"star"] highlightedStar:[UIImage imageNamed:@"star_highlighted"] atIndex:0];
        [self.starControl setStar:[UIImage imageNamed:@"star"] highlightedStar:[UIImage imageNamed:@"star_highlighted"] atIndex:1];
    } else {
        self.adviceTextView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1];
        [self.starControl setStar:[UIImage imageNamed:@"star"] highlightedStar:[UIImage imageNamed:@"star_red_highlighted"] atIndex:0];
        [self.starControl setStar:[UIImage imageNamed:@"star"] highlightedStar:[UIImage imageNamed:@"star_red_highlighted"] atIndex:1];
    }

    [self.tableView addSubview:self.adviceTextView];
    
    self.surveyTitleLabel.frame = CGRectMake(17, 160, 88, 22);
    self.sepImageView2.frame = CGRectMake(20, 185, 280, 2);
    self.disciplineBtn1.frame = CGRectMake(55, 200, 86, 40);
    self.disciplineBtn2.frame = CGRectMake(141, 200, 78, 40);
    self.disciplineBtn3.frame = CGRectMake(219, 200, 86, 40);
    self.attendanceBtn1.frame = CGRectMake(55, 250, 86, 40);
    self.attendanceBtn2.frame = CGRectMake(141, 250, 78, 40);
    self.attendanceBtn3.frame = CGRectMake(219, 250, 86, 40);
    self.speedBtn1.frame = CGRectMake(55, 300, 86, 40);
    self.speedBtn2.frame = CGRectMake(141, 300, 78, 40);
    self.speedBtn3.frame = CGRectMake(219, 300, 86, 40);
    self.sepImageView3.frame = CGRectMake(20, 360, 280, 2);
    self.anonymityLabel.frame = CGRectMake(20, 380, 280, 21);
    self.planLabel.frame = CGRectMake(20, 210, 30, 20);
    self.attendanceLabel.frame = CGRectMake(20, 260, 30, 20);
    self.speedLabel.frame = CGRectMake(20, 310, 30, 20);
    self.adviceTextView.frame = CGRectMake(20, 275, 280, 100);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
    [self showErrorAlertUsingString:@"提交失败，请检查网络。"];
    [connection cancel];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self animateBackLoadingView];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    [self.delegate willDismissEventDetailViewController];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self showErrorAlertUsingString:[NSString stringWithFormat:@"%@", self.evaluationInfo]];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data) {
        NSDictionary *result = nil;
        NSError *error = nil;
        result = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                   error:&error];
        self.evaluationInfo = [result valueForKey:@"msg"];
        if ([self.evaluationInfo isEqualToString:@"succeed :)"]) {
            self.evaluationInfo = @"发布成功";
        } else if ([self.evaluationInfo isEqualToString:@"out of time scope"]) {
            self.evaluationInfo = @"现在还不能反馈哦~";
        }
    }
}

#define EVALUATION_URL @"http://app.njut.org.cn/timetable/advice.action"

- (void)startConnectingWithPostString:(NSString *)postString
{
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:EVALUATION_URL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 20;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

#define POST_EVALUATION_FORMAT @"ctid=%@&effect=%d&arrangement=%d&attendance=%d&speed=%d&content=%@&schoolnumber=%@&endtime=%@&starttime=%@"

- (void)donePresenting
{
    [self.view endEditing:YES];
    if ((self.disciplineRating == 0) ||
        (self.disciplineRating == 1 && self.overallRating == 0) ||
        (self.disciplineRating == 1 && (self.attendanceRating == 0 || self.speedRating == 0))) {
        [self showErrorAlertUsingString:@"学习效果和教学情况为必填项"];
    } else {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        if (!self.starControl.enabled) {
            self.overallRating = 0;
        }
        if (!self.adviceTextView.editable) {
            self.adviceTextView.text = @"";
        }
        NSString *postString = [NSString stringWithFormat:POST_EVALUATION_FORMAT, self.ctid, self.overallRating, self.disciplineRating, self.attendanceRating, self.speedRating, [self.adviceTextView text], [[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"], self.endTime, self.startTime];
        [self startConnectingWithPostString:postString];
        [self animateLoadingView];
        NSLog(@"%@", postString);
    }
}

- (void)cancelPresenting
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate willDismissEventDetailViewController];
}

- (void)animateLoadingView
{
    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0)];
    } else {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    }
    //self.loadingView.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:85.0/255.0 blue:158.0/255.0 alpha:1];
    self.loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingView];
    [UIView animateWithDuration:0.24 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
            self.loadingView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44);
        } else {
            self.loadingView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 64);
        }
        self.loadingView.alpha = 0.8;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
                    self.loadingView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44 - 30);
                } else {
                    self.loadingView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 64 - 30);
                }
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
                            self.loadingView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44);
                        } else {
                            self.loadingView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 64);
                        }
                    } completion:nil];
                }
            }];
        }
    }];
}

- (void)animateBackLoadingView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.loadingView.frame = CGRectMake(0, 0, 320, 0);
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.loadingView removeFromSuperview];
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

- (void)moveTableViewForKeyboard:(NSNotification *)notification Up:(BOOL)up
{
    if (up) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 180, 320, self.tableView.frame.size.height) animated:YES];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self moveTableViewForKeyboard:notification Up:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self moveTableViewForKeyboard:notification Up:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.evaluationGrid.hidden = NO;
    self.evaluationGrid.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.evaluationGrid.alpha = 0.75;
    }];
}

#define BACKGROUND_PATTERN_IMAGE_NAME @"evaluation_bg.png"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.courseNameLabel.text = self.courseName;
    self.coursePropertyLabel.text = self.courseProperty;
    self.teacherNameLabel.text = self.teacherName;
    if ([self.credit integerValue]) {
        self.creditLabel.text = [NSString stringWithFormat:@"%@ 学分", self.credit];
    } else {
        self.creditLabel.text = nil;
    }
    
    int randomNumber = (arc4random() % 4) + 1;
    UIImage *randomCourseImage = [UIImage imageNamed:[NSString stringWithFormat:@"course_bg-%u.png", randomNumber]];
    self.courseImageView.image = randomCourseImage;
}

#define GESTURE_TRIGGER_OFFSET 40.0f

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.courseImageView.clipsToBounds = YES;
    
    self.view.keyboardTriggerOffset = GESTURE_TRIGGER_OFFSET;
    [self.view addKeyboardPanningWithActionHandler:nil];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg_ios6"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ UITextAttributeFont : [UIFont systemFontOfSize:19.0], UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero] }];
    } else {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] }];
    }

    DLStarRatingControl *star = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(0, 226, 320, 54)];
    star.delegate = self;
    self.starControl = star;
    [self.tableView addSubview:star];
    
    self.surveyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 60, 88, 22)];
    self.surveyTitleLabel.text = @"教学情况 *";
    self.surveyTitleLabel.font = [UIFont systemFontOfSize:15.0];
    self.surveyTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.effectCell addSubview:self.surveyTitleLabel];
    self.sepImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 85, 280, 2)];
    self.sepImageView2.image = [UIImage imageNamed:@"evaluation_separator"];
    self.sepImageView2.alpha = 0.5;
    [self.effectCell addSubview:self.sepImageView2];
    
    self.planLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 30, 20)];
    self.planLabel.text = @"安排";
    self.planLabel.textColor = [UIColor lightGrayColor];
    self.planLabel.font = [UIFont systemFontOfSize:15.0];
    [self.effectCell addSubview:self.planLabel];
    self.attendanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 30, 20)];
    self.attendanceLabel.text = @"到课";
    self.attendanceLabel.textColor = [UIColor lightGrayColor];
    self.attendanceLabel.font = [UIFont systemFontOfSize:15.0];
    [self.effectCell addSubview:self.attendanceLabel];
    self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 30, 20)];
    self.speedLabel.text = @"进度";
    self.speedLabel.textColor = [UIColor lightGrayColor];
    self.speedLabel.font = [UIFont systemFontOfSize:15.0];
    [self.effectCell addSubview:self.speedLabel];
    
    self.disciplineBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(55, 100, 86, 40)];
    self.disciplineBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(141, 100, 78, 40)];
    self.disciplineBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(219, 100, 86, 40)];
    self.attendanceBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(55, 150, 86, 40)];
    self.attendanceBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(141, 150, 78, 40)];
    self.attendanceBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(219, 150, 86, 40)];
    self.speedBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(55, 200, 86, 40)];
    self.speedBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(141, 200, 78, 40)];
    self.speedBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(219, 200, 86, 40)];
    [self.disciplineBtn1 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"正常" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    [self.disciplineBtn2 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"调课" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    [self.disciplineBtn3 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"停课" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    [self.attendanceBtn1 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"<50%" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    [self.attendanceBtn2 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"≈70%" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    [self.attendanceBtn3 setAttributedTitle:[[NSAttributedString alloc] initWithString:@">90%" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    [self.speedBtn1 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"较慢" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    [self.speedBtn2 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"适中" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    [self.speedBtn3 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"较快" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateNormal];
    
    [self.disciplineBtn1 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"正常" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    [self.disciplineBtn2 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"调课" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    [self.disciplineBtn3 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"停课" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    [self.attendanceBtn1 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"<50%" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    [self.attendanceBtn2 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"≈70%" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    [self.attendanceBtn3 setAttributedTitle:[[NSAttributedString alloc] initWithString:@">90%" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    [self.speedBtn1 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"较慢" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    [self.speedBtn2 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"适中" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    [self.speedBtn3 setAttributedTitle:[[NSAttributedString alloc] initWithString:@"较快" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0] }] forState:UIControlStateSelected];
    
    [self.disciplineBtn1 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_left"] forState:UIControlStateNormal];
    [self.disciplineBtn2 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_center"] forState:UIControlStateNormal];
    [self.disciplineBtn3 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_right"] forState:UIControlStateNormal];
    [self.attendanceBtn1 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_left"] forState:UIControlStateNormal];
    [self.attendanceBtn2 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_center"] forState:UIControlStateNormal];
    [self.attendanceBtn3 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_right"] forState:UIControlStateNormal];
    [self.speedBtn1 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_left"] forState:UIControlStateNormal];
    [self.speedBtn2 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_center"] forState:UIControlStateNormal];
    [self.speedBtn3 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_right"] forState:UIControlStateNormal];
    [self.disciplineBtn1 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_left_selected"] forState:UIControlStateSelected];
    [self.disciplineBtn2 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_center_selected"] forState:UIControlStateSelected];
    [self.disciplineBtn3 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_right_selected"] forState:UIControlStateSelected];
    [self.attendanceBtn1 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_left_selected"] forState:UIControlStateSelected];
    [self.attendanceBtn2 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_center_selected"] forState:UIControlStateSelected];
    [self.attendanceBtn3 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_right_selected"] forState:UIControlStateSelected];
    [self.speedBtn1 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_left_selected"] forState:UIControlStateSelected];
    [self.speedBtn2 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_center_selected"] forState:UIControlStateSelected];
    [self.speedBtn3 setBackgroundImage:[UIImage imageNamed:@"evaluation_option_button_right_selected"] forState:UIControlStateSelected];
    [self.disciplineBtn1 addTarget:self action:@selector(disciplineBtn1Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.disciplineBtn2 addTarget:self action:@selector(disciplineBtn2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.disciplineBtn3 addTarget:self action:@selector(disciplineBtn3Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.attendanceBtn1 addTarget:self action:@selector(attendanceBtn1Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.attendanceBtn2 addTarget:self action:@selector(attendanceBtn2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.attendanceBtn3 addTarget:self action:@selector(attendanceBtn3Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.speedBtn1 addTarget:self action:@selector(speedBtn1Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.speedBtn2 addTarget:self action:@selector(speedBtn2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.speedBtn3 addTarget:self action:@selector(speedBtn3Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.effectCell.contentView addSubview:self.disciplineBtn1];
    [self.effectCell.contentView addSubview:self.disciplineBtn2];
    [self.effectCell.contentView addSubview:self.disciplineBtn3];
    [self.effectCell.contentView addSubview:self.attendanceBtn1];
    [self.effectCell.contentView addSubview:self.attendanceBtn2];
    [self.effectCell.contentView addSubview:self.attendanceBtn3];
    [self.effectCell.contentView addSubview:self.speedBtn1];
    [self.effectCell.contentView addSubview:self.speedBtn2];
    [self.effectCell.contentView addSubview:self.speedBtn3];
    
    self.sepImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 260, 280, 2)];
    self.sepImageView3.image = [UIImage imageNamed:@"evaluation_sep2"];
    self.sepImageView3.alpha = 0.5;
    [self.effectCell addSubview:self.sepImageView3];
    self.anonymityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, 280, 21)];
    self.anonymityLabel.text = @"你所填写的所有信息都将被匿名发送。";
    self.anonymityLabel.textColor = [UIColor darkGrayColor];
    self.anonymityLabel.font = [UIFont systemFontOfSize:13.0];
    self.anonymityLabel.textAlignment = NSTextAlignmentCenter;
    [self.effectCell addSubview:self.anonymityLabel];
    
    self.evaluationGrid.hidden = YES;
    
    UIImage *barCancelButtonImage = [[UIImage alloc] init];
    UIImage *barConfirmButtonImage = [[UIImage alloc] init];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        barCancelButtonImage = [UIImage imageNamed:@"toolbar_item_icon_cancel.png"];
        barConfirmButtonImage = [UIImage imageNamed:@"toolbar_item_icon_confirm.png"];
    } else {
        barCancelButtonImage = [UIImage imageNamed:@"toolbar_item_icon_cancel_blue.png"];
        barConfirmButtonImage = [UIImage imageNamed:@"toolbar_item_icon_confirm_blue.png"];
    }
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] init];
    cancel = [UIBarButtonItem barItemWithImage:barCancelButtonImage
                                        target:self
                                        action:@selector(cancelPresenting)
                                    edgeInsets:UIEdgeInsetsZero
                                         width:barCancelButtonImage.size.width
                                        height:barCancelButtonImage.size.height];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] init];
    done = [UIBarButtonItem barItemWithImage:barConfirmButtonImage
                                      target:self
                                      action:@selector(donePresenting)
                                  edgeInsets:UIEdgeInsetsZero
                                       width:barConfirmButtonImage.size.width
                                      height:barConfirmButtonImage.size.height];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = done;
    
    [self initAdviceTextView];
    self.adviceTextView.backgroundColor = [UIColor lightGrayColor];
}

@end
