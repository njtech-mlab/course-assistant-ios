//
//  ModifyPasswordViewController.m
//  课程助理
//
//  Created by Jason J on 13-5-27.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ModifyPasswordViewController.h"
#import "CalendarToolbar.h"
#import "UIBarButtonItem+Custom.h"
#import "LoginTextField.h"
#import "CommonFetch.h"

@interface ModifyPasswordViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate, UIToolbarDelegate>
@property (weak, nonatomic) IBOutlet CalendarToolbar *calendarToolbar;
@property (weak, nonatomic) IBOutlet LoginTextField *originalPwdTextField;
@property (weak, nonatomic) IBOutlet LoginTextField *theNewPwdTextField;
@property (weak, nonatomic) IBOutlet LoginTextField *repeatNewPwdTextField;
@property (weak, nonatomic) IBOutlet UIView *forbiddenView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) NSTimer *backgroundTimer;
@end

@implementation ModifyPasswordViewController

- (void)switchNetworkActivityIndicatorVisibleTo:(BOOL)boolean
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = boolean;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    [self showAlertUsingString:@"修改失败，请重试。"];
    self.forbiddenView.hidden = YES;
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
    [self stopBackgroundTimer];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    NSLog(@"%@", error.localizedDescription);
    [connection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self stopBackgroundTimer];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    [connection cancel];
    [self.delegate willDismissModifyPasswordViewController];
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAlertUsingString:@"修改成功，请重新登录 :)"];
        [self.delegate haveModifiedPassword];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data) {
        NSString *message = [[CommonFetch fetchData:data] objectForKey:@"msg"];
        NSLog(@"%@", message);
    } else {
        [connection cancel];
        [self showAlertUsingString:@"修改失败，请重试。"];
        self.forbiddenView.hidden = YES;
        self.spinner.hidden = YES;
        [self.spinner stopAnimating];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
    }
}

#define CHANGE_PASSWORD_URL @"http://app.njut.org.cn/timetable/changepassword.action"

- (void)startConnectingWithPostString:(NSString *)postString
{
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:CHANGE_PASSWORD_URL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[conn start];
    self.forbiddenView.hidden = NO;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
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
    [self showAlertUsingString:@"修改失败，请检查网络。"];
    self.forbiddenView.hidden = YES;
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
}

- (void)stopBackgroundTimer
{
    [self.backgroundTimer invalidate];
}

- (void)cancelPresenting
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate willDismissModifyPasswordViewController];
}

- (void)donePresenting
{
    if (!(self.originalPwdTextField.text.length && self.theNewPwdTextField.text.length && self.repeatNewPwdTextField.text.length)) {
        [self showAlertUsingString:@"信息不完整"];
    } else if (![self.theNewPwdTextField.text isEqualToString:self.repeatNewPwdTextField.text]) {
        [self showAlertUsingString:@"新密码与确认密码不一致"];
    } else if (![self.originalPwdTextField.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]]) {
        [self showAlertUsingString:@"原密码输入错误"];
    } else if ([self.theNewPwdTextField.text isEqualToString:self.repeatNewPwdTextField.text] && [self.theNewPwdTextField.text isEqualToString:self.originalPwdTextField.text]) {
        [self showAlertUsingString:@"新密码不能与原密码相同"];
    } else {
        NSString *postString = [NSString stringWithFormat:@"email=%@&originalpassword=%@&newpassword=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"email"], self.originalPwdTextField.text, self.theNewPwdTextField.text];
        NSLog(@"%@", postString);
        [self startConnectingWithPostString:postString];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.originalPwdTextField) {
        [self.theNewPwdTextField becomeFirstResponder];
    } else if (textField == self.theNewPwdTextField) {
        [self.repeatNewPwdTextField becomeFirstResponder];
    }
    return NO;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        self.calendarToolbar.frame = CGRectMake(0, 0, 320, 44);
        self.originalPwdTextField.frame = CGRectMake(50, 60, 220, 42);
        self.theNewPwdTextField.frame = CGRectMake(50, 110, 220, 42);
        self.repeatNewPwdTextField.frame = CGRectMake(50, 160, 220, 42);
        self.forbiddenView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44);
        self.titleLabel.frame = CGRectMake(111, 9, 98, 25);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.originalPwdTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendarToolbar.delegate = self;
    
    self.originalPwdTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.originalPwdTextField.layer.borderWidth = 1.0;
    self.theNewPwdTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.theNewPwdTextField.layer.borderWidth = 1.0;
    self.repeatNewPwdTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.repeatNewPwdTextField.layer.borderWidth = 1.0;
    self.originalPwdTextField.placeholder = @"请输入原密码";
    self.theNewPwdTextField.placeholder = @"请输入新密码";
    self.repeatNewPwdTextField.placeholder = @"请重新输入新密码";
    self.originalPwdTextField.secureTextEntry = YES;
    self.theNewPwdTextField.secureTextEntry = YES;
    self.repeatNewPwdTextField.secureTextEntry = YES;
    self.originalPwdTextField.returnKeyType = UIReturnKeyNext;
    self.theNewPwdTextField.returnKeyType = UIReturnKeyNext;
    
    self.originalPwdTextField.delegate = self;
    self.theNewPwdTextField.delegate = self;
    self.repeatNewPwdTextField.delegate = self;
    
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
