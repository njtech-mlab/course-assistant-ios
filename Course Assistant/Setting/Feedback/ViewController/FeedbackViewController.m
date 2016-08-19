//
//  FeedbackViewController.m
//  课程助理
//
//  Created by Jason J on 10/15/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CalendarToolbar.h"
#import "UIBarButtonItem+Custom.h"
#import "EvaluationTextView.h"
#import "CommonFetch.h"

@interface FeedbackViewController () <NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIToolbarDelegate>
@property (weak, nonatomic) IBOutlet CalendarToolbar *calendarToolbar;
@property (weak, nonatomic) IBOutlet EvaluationTextView *feedbackTextView;
@property (strong, nonatomic) UIView *blueloadingView;
@property (nonatomic) CGRect originalTextViewFrame;
@property (weak, nonatomic) NSTimer *backgroundTimer;
@end

@implementation FeedbackViewController

- (void)switchNetworkActivityIndicatorVisibleTo:(BOOL)boolean
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = boolean;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    [self showAlertUsingString:@"发送失败，请重试。"];
    [self animateOutLoadingView];
    [self stopBackgroundTimer];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    NSLog(@"%@", error.localizedDescription);
    [connection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self stopBackgroundTimer];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    [self.delegate willDismissFeedbackViewController];
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAlertUsingString:@"发送成功，感谢反馈 :)"];
    }];
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data) {
        NSString *message = [[CommonFetch fetchData:data] objectForKey:@"msg"];
        NSLog(@"%@", message);
    } else {
        [connection cancel];
        [self showAlertUsingString:@"发送失败，请重试。"];
        [self animateOutLoadingView];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
    }
}

#define FEEDBACK_URL @"http://app.njut.org.cn/timetable/feedback.action"

- (void)startConnectingWithPostString:(NSString *)postString
{
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:FEEDBACK_URL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[conn start];
    [self animateLoadingView];
    [self.view endEditing:YES];
    [self startConnectionOvertimeTimer:conn];
    [self switchNetworkActivityIndicatorVisibleTo:YES];
}

- (void)showAlertUsingString:(NSString *)errorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#define TIMER_INTERVAL 6

- (void)startConnectionOvertimeTimer:(NSURLConnection *)connction
{
    self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                            target:self
                                                          selector:@selector(connectionOvertime:)
                                                          userInfo:connction
                                                           repeats:NO];
}

- (void)connectionOvertime:(NSTimer *)timer
{
    [(NSURLConnection *)[timer userInfo] cancel];
    [self showAlertUsingString:@"发送失败，请检查网络。"];
    [self animateOutLoadingView];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
}

- (void)stopBackgroundTimer
{
    [self.backgroundTimer invalidate];
}

- (void)animateLoadingView
{
    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        self.blueloadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0)];
    } else {
        self.blueloadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 0)];
    }
    self.blueloadingView.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:85.0/255.0 blue:158.0/255.0 alpha:1];
    [self.view addSubview:self.blueloadingView];
    [UIView animateWithDuration:0.24 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
            self.blueloadingView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44);
        } else {
            self.blueloadingView.frame = CGRectMake(0, 64, 320, self.view.frame.size.height - 64);
        }
        self.blueloadingView.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
                self.blueloadingView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44 - 20);
            } else {
                self.blueloadingView.frame = CGRectMake(0, 64, 320, self.view.frame.size.height - 64 - 20);
            }
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
                        self.blueloadingView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44);
                    } else {
                        self.blueloadingView.frame = CGRectMake(0, 64, 320, self.view.frame.size.height - 64);
                    }
                } completion:nil];
            }
        }];
    }];
}

- (void)animateOutLoadingView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.blueloadingView.frame = CGRectMake(0, 44, 320, 0);
        self.blueloadingView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.blueloadingView removeFromSuperview];
        }
    }];
}

#define POST_FEEDBACK_STRING_FORMAT @"schoolnumber=%@&content=%@"

- (void)donePresenting
{
    NSString *studentID = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"];
    NSString *content = [NSString stringWithFormat:@"[iOS]%@", self.feedbackTextView.text];
    [self startConnectingWithPostString:[NSString stringWithFormat:POST_FEEDBACK_STRING_FORMAT, studentID, content]];
}

- (void)cancelPresenting
{
    [self.delegate willDismissFeedbackViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moveTextViewForKeyboard:(NSNotification*)notification up:(BOOL)up
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (up == YES) {
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect newTextViewFrame = self.feedbackTextView.frame;
        self.originalTextViewFrame = self.feedbackTextView.frame;
        newTextViewFrame.size.height = keyboardTop - self.feedbackTextView.frame.origin.y - 20;
        self.feedbackTextView.frame = newTextViewFrame;
    } else {
        self.feedbackTextView.frame = self.originalTextViewFrame;
    }
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveTextViewForKeyboard:notification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveTextViewForKeyboard:notification up:NO];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self.feedbackTextView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#define PLACEHOLDER @"为了提高你的用户体验，欢迎反馈如下方面的信息：\r\n1) 使用过程中出现的问题。\r\n2) 期待的新功能。\r\n3) 欢迎吐槽任何细节问题。"
#define FONT_SIZE 15.0

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendarToolbar.delegate = self;
    
    self.feedbackTextView.placeholder = PLACEHOLDER;
    self.feedbackTextView.placeholderColor = [UIColor lightGrayColor];
    self.feedbackTextView.textColor = [UIColor darkGrayColor];
    self.feedbackTextView.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    //self.view.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    
    UIImage *barCancelButtonImage = [UIImage imageNamed:@"toolbar_item_icon_cancel.png"];
    UIImage *barConfirmButtonImage = [UIImage imageNamed:@"toolbar_item_icon_confirm.png"];
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
    UIBarButtonItem *measurement = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.calendarToolbar.items = [NSArray arrayWithObjects:cancel, measurement, done, nil];
}

@end
