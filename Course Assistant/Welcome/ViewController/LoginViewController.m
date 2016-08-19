//
//  LoginViewController.m
//  南工云课堂
//
//  Created by Jason J on 13-4-18.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "LoginViewController.h"
#import "InitialSlidingViewController.h"
#import "TeacherRootTBVC.h"
#import "UserInfoFetcher.h"
#import "CalendarDataFetcher.h"
#import "User+NJTech.h"
#import "Course+NJTech.h"
#import "Stream+Evaluate.h"
#import "Notification+Recipient.h"
#import "UIDevice-Hardware.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIManagedDocumentHandler.h"

@interface LoginViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate, ASIHTTPRequestDelegate>
@property (strong, nonatomic) NSManagedObjectContext *notificationManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *userManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) NSArray *calendarData;
@property (nonatomic) BOOL userIsNotVerified;
@property (nonatomic) bool isTeacher;
@property (weak, nonatomic) id <UIManagedDocumentHandlerDelegate> managedDocumentHandlerDelegate;
@end

@implementation LoginViewController

- (id <UIManagedDocumentHandlerDelegate>)managedDocumentHandlerDelegate
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if(!_managedDocumentHandlerDelegate && [appDelegate conformsToProtocol: @protocol(UIManagedDocumentHandlerDelegate)]) {
        return appDelegate;
    }
    return _managedDocumentHandlerDelegate;
}

- (void)setUsernameTextField:(UITextField *)usernameTextField
{
    _usernameTextField = usernameTextField;
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.delegate = self;
}

- (void)setPasswordTextField:(UITextField *)passwordTextField
{
    _passwordTextField = passwordTextField;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
}

#define ANIMATION_DURATION 0.3
#define STUDENT_SEGUE_IDENTIFIER @"Login"
#define TEACHER_SEGUE_IDENTIFIER @"Teacher Login"

- (void)saveCalendarDataToCoreData
{
    [self.managedObjectContext performBlock:^{
        for (NSDictionary *course in self.calendarData) {
            if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
                if ([[course objectForKey:@"schedule"] count]) {
                    for (NSDictionary *schedule in (NSArray *)[course objectForKey:@"schedule"]) {
                        NSDictionary *separatedCourse = @{ @"courseCategory" : [course objectForKey:@"courseCategory"],
                                                           @"courseNature" : [course objectForKey:@"courseNature"],
                                                           @"coursename" : [course objectForKey:@"coursename"],
                                                           @"credit" : [course objectForKey:@"credit"],
                                                           @"ctid" : [course objectForKey:@"ctid"],
                                                           @"natureclass" : [course objectForKey:@"natureclass"],
                                                           @"beginsection" : [schedule objectForKey:@"beginsection"],
                                                           @"beginweek" : [schedule objectForKey:@"beginweek"],
                                                           @"day" : [schedule objectForKey:@"day"],
                                                           @"endsection" : [schedule objectForKey:@"endsection"],
                                                           @"endweek" : [schedule objectForKey:@"endweek"],
                                                           @"oddoreven" : [schedule objectForKey:@"oddoreven"],
                                                           @"place" : [schedule objectForKey:@"place"] };
                        [Course courseWithInfo:separatedCourse inManagedContext:self.managedObjectContext];
                    }
                } else {
                    [Course courseWithInfo:course inManagedContext:self.managedObjectContext];
                }
            } else {
                [Course courseWithInfo:course inManagedContext:self.managedObjectContext];
            }
        }
        //[Stream streamWithInfo:nil inManagedContext:self.managedObjectContext];
    }];
    [self startConnectionWithPostDeviceType:@"iOS" deviceToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] systemVersion:[NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].platformString, [UIDevice currentDevice].systemVersion]];
}

- (void)creatCalendarDocument
{
    NSURL *calendarUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                 inDomains:NSUserDomainMask] lastObject];
    calendarUrl = [calendarUrl URLByAppendingPathComponent:@"Calendar Document"];
    UIManagedDocument *document = nil;
    document = [[UIManagedDocument alloc] initWithFileURL:calendarUrl];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[calendarUrl path]]) {
        [document saveToURL:calendarUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                self.managedDocumentHandlerDelegate.calendarDocument = document;
                [self saveCalendarDataToCoreData];
            }
        }];
    } else {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[calendarUrl path] error:&error];
        if (success) {
            [self creatCalendarDocument];
        } else if (!success) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
}

- (void)saveUserDataToCoreData
{
    [self.userManagedObjectContext performBlock:^{
        [User userWithInfo:self.userInfo inManagedContext:self.userManagedObjectContext];
    }];
}

- (void)creatUserDocument
{
    NSURL *userUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
    if (self.isTeacher) {
        userUrl = [userUrl URLByAppendingPathComponent:@"Teacher Document"];
    } else {
        userUrl = [userUrl URLByAppendingPathComponent:@"Student Document"];
    }
    UIManagedDocument *document = nil;
    document = [[UIManagedDocument alloc] initWithFileURL:userUrl];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[userUrl path]]) {
        [document saveToURL:userUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                self.userManagedObjectContext = document.managedObjectContext;
                [self saveUserDataToCoreData];
            }
        }];
    } else {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[userUrl path] error:&error];
        if (success) {
            [self creatUserDocument];
        } else if (!success) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
}

- (void)deviceInfoRequestDidFail:(ASIHTTPRequest *)request
{
    [self.spinner stopAnimating];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogined"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.isTeacher) {
        [self performSegueWithIdentifier:TEACHER_SEGUE_IDENTIFIER sender:nil];
    } else {
        [self performSegueWithIdentifier:STUDENT_SEGUE_IDENTIFIER sender:nil];
    }
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.welcomeScrollView.alpha = 0;
    }];
}

- (void)deviceInfoRequestDidFinishLoading:(ASIHTTPRequest *)request
{
    [self.spinner stopAnimating];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogined"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.isTeacher) {
        [self performSegueWithIdentifier:TEACHER_SEGUE_IDENTIFIER sender:nil];
    } else {
        [self performSegueWithIdentifier:STUDENT_SEGUE_IDENTIFIER sender:nil];
    }
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.welcomeScrollView.alpha = 0;
    }];
}

#define DEVICE_INFO_URL @"http://app.njut.org.cn/timetable/senddeviceinfo.action"

- (void)startConnectionWithPostDeviceType:(NSString *)deviceType deviceToken:(NSString *)deviceToken systemVersion:(NSString *)systemVersion
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:DEVICE_INFO_URL]];
    [request setPostValue:deviceType forKey:@"deviceType"];
    [request setPostValue:deviceToken forKey:@"deviceToken"];
    [request setPostValue:systemVersion forKey:@"systemVersion"];
    [request setRequestMethod:@"POST"];
    request.delegate = self;
    request.didFinishSelector = @selector(deviceInfoRequestDidFinishLoading:);
    request.didFailSelector = @selector(deviceInfoRequestDidFail:);
    request.timeOutSeconds = 10;
    [request startAsynchronous];
    [self switchNetworkActivityIndicatorVisibleTo:YES];
}

- (void)cookieRequestDidFail:(ASIHTTPRequest *)request
{
    [self showErrorAlertUsingString:@"获取用户信息失败，请检查网络。"];
    self.usernameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    [self.spinner stopAnimating];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    NSError *error = [request error];
    NSLog(@"%@", error.localizedDescription);
}

- (void)cookieRequestDidFinishLoading:(ASIHTTPRequest *)cookieRequest
{
    if ([cookieRequest responseData]) {
        self.calendarData = [CalendarDataFetcher fetchCalendarData:[cookieRequest responseData]];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
        if (!self.managedObjectContext) {
            [self creatCalendarDocument];
        }
    } else {
        [self showErrorAlertUsingString:@"获取用户信息失败，请重试。"];
        self.usernameTextField.enabled = YES;
        self.passwordTextField.enabled = YES;
        [self.spinner stopAnimating];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
    }
}

#define STUDENT_CURRICULUM_URL @"http://app.njut.org.cn/timetable/curriculum.action"
#define TEACHER_CURRICULUM_URL @"http://app.njut.org.cn/timetable/fetchcurriculum.action"

- (void)startConnectionWithCookie
{
    NSString *urlString;
    if (self.isTeacher) {
        urlString = TEACHER_CURRICULUM_URL;
    } else {
        urlString = STUDENT_CURRICULUM_URL;
    }
    ASIHTTPRequest *cookieRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    cookieRequest.delegate = self;
    cookieRequest.didFinishSelector = @selector(cookieRequestDidFinishLoading:);
    cookieRequest.didFailSelector = @selector(cookieRequestDidFail:);
    cookieRequest.timeOutSeconds = 20;
    [cookieRequest startAsynchronous];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    [self showErrorAlertUsingString:@"连接失败，请检查网络。"];
    self.usernameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    [self.spinner stopAnimating];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    NSLog(@"%@", error.localizedDescription);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    if (self.userIsNotVerified) {
        [self showErrorAlertUsingString:@"用户名或密码错误！"];
        self.usernameTextField.enabled = YES;
        self.passwordTextField.enabled = YES;
        [self.spinner stopAnimating];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
    } else {
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        if ([[cookieJar cookies] count]) {
            [[NSUserDefaults standardUserDefaults] setValue:self.usernameTextField.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:@"password"];
            [self startConnectionWithCookie];
            if (!self.userManagedObjectContext) {
                [self creatUserDocument];
            }
        } else {
            [self showErrorAlertUsingString:@"获取用户信息失败，请重试。"];
            self.usernameTextField.enabled = YES;
            self.passwordTextField.enabled = YES;
            [self.spinner stopAnimating];
            [self switchNetworkActivityIndicatorVisibleTo:NO];
        }
    }
}

#define LOGIN_SUCCESS_STRING @"login succeed"

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@", [UserInfoFetcher fetchUserInfo:data]);
    if (data) {
        if (![[UserInfoFetcher fetchUserInfo:data] valueForKey:@"msg"]) {
            self.userInfo = [UserInfoFetcher fetchUserInfo:data];
        } else {
            self.userIsNotVerified = YES;
        }
    } else {
        [connection cancel];
        [self showErrorAlertUsingString:@"获取用户信息失败，请重试。"];
        self.usernameTextField.enabled = YES;
        self.passwordTextField.enabled = YES;
        [self.spinner stopAnimating];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
    }
}

- (void)startConnectingWithPostString:(NSString *)postString andURLString:(NSString *)urlString
{
    self.userIsNotVerified = NO;

    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 20;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    [self switchNetworkActivityIndicatorVisibleTo:YES];
}

#define STUDENT_LOGIN_FORMAT @"email=%@&password=%@"
#define TEACHER_LOGIN_FORMAT @"personnelnumber=%@&password=%@"

#define STUDENT_INFO_URL @"http://app.njut.org.cn/timetable/login.action"
#define TEACHER_INFO_URL @"http://app.njut.org.cn/timetable/teacherlogin.action"

- (void)loginPressed
{
    if ([self.usernameTextField.text length] == 0) {
        [self showErrorAlertUsingString:@"请填写用户名！"];
    } else if ([self.passwordTextField.text length] == 0) {
        [self showErrorAlertUsingString:@"请填写密码！"];
    } else {
        [self.view endEditing:YES];
        self.usernameTextField.enabled = NO;
        self.passwordTextField.enabled = NO;
        [self.spinner startAnimating];
        if ([self.usernameTextField.text length] <= 5) {
            self.isTeacher = YES;
            [self startConnectingWithPostString:[NSString stringWithFormat:TEACHER_LOGIN_FORMAT, self.usernameTextField.text, self.passwordTextField.text] andURLString:TEACHER_INFO_URL];
        } else {
            self.isTeacher = NO;
            [self startConnectingWithPostString:[NSString stringWithFormat:STUDENT_LOGIN_FORMAT, self.usernameTextField.text, self.passwordTextField.text] andURLString:STUDENT_INFO_URL];
        }
    }
}

- (void)switchNetworkActivityIndicatorVisibleTo:(BOOL)boolean
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = boolean;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self loginPressed];
    }
    return NO;
}

- (void)connectionOvertime:(NSTimer *)timer
{
    [(NSURLConnection *)[timer userInfo] cancel];
    [self showErrorAlertUsingString:@"连接失败，请检查网络。"];
    self.usernameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    [self.spinner stopAnimating];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:STUDENT_SEGUE_IDENTIFIER]) {
        if ([segue isKindOfClass:[InitialSlidingViewController class]]) {
            InitialSlidingViewController *initialSlidingVC;
            initialSlidingVC = segue.destinationViewController;
        }
    } else if ([segue.identifier isEqualToString:TEACHER_SEGUE_IDENTIFIER]) {
        if ([segue isKindOfClass:[TeacherRootTBVC class]]) {
            TeacherRootTBVC *teacherRTBVC;
            teacherRTBVC = segue.destinationViewController;
        }
    }
}

@end
