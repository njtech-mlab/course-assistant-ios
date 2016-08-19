//
//  TeacherSettingTVC.m
//  课程助理
//
//  Created by Jason J on 2/12/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "TeacherSettingTVC.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ECSlidingViewController.h"
#import "ModifyPasswordViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"

@interface TeacherSettingTVC () <ModifyPasswordViewControllerDelegate, AboutViewControllerDelegate, FeedbackViewControllerDelegate, UITableViewDelegate, UIActionSheetDelegate, ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *groupOneCellOne;
@property (weak, nonatomic) IBOutlet UITableViewCell *groupOneCellTwo;
@property (weak, nonatomic) IBOutlet UISwitch *commentNotificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *systemNotificationSwitch;
@property (weak, nonatomic) UIActionSheet *logoutActionSheet;
@end

@implementation TeacherSettingTVC

- (void)willDismissModifyPasswordViewController
{
    self.view.superview.superview.superview.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.superview.superview.superview.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)haveModifiedPassword
{
    [self startConnectionWithPostDeviceType:@"iOS" userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    [self logout];
}

- (void)willDismissAboutViewController
{
    self.view.superview.superview.superview.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.superview.superview.superview.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)willDismissFeedbackViewController
{
    self.view.superview.superview.superview.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.superview.superview.superview.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

#define APP_URL @"itms-apps://itunes.apple.com/us/app/ke-cheng-zhu-li/id659541624?ls=1&mt=8"

- (IBAction)evaluateUsPressed:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
}

#define ACTION_SHEET_TITLE @"你确定要注销吗？"
#define ACTION_SHEET_LOGOUT @"注销"
#define ACTION_SHEET_CANCEL @"取消"
#define SEGUE_IDENTIFIER @"Teacher Logout"

- (IBAction)logoutPressed:(UIButton *)sender
{
    // Pop up action sheet
    if (!self.logoutActionSheet) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:ACTION_SHEET_TITLE
                                                                 delegate:self
                                                        cancelButtonTitle:ACTION_SHEET_CANCEL
                                                   destructiveButtonTitle:ACTION_SHEET_LOGOUT
                                                        otherButtonTitles:nil, nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showFromRect:sender.frame inView:self.view animated:YES];
        self.logoutActionSheet = actionSheet;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Logout
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self startConnectionWithPostDeviceType:@"iOS" userName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
        [self logout];
    }
}

- (void)deviceInfoRequestDidFail:(ASIHTTPRequest *)request
{
    [self switchNetworkActivityIndicatorVisibleTo:NO];
}

- (void)deviceInfoRequestDidFinishLoading:(ASIHTTPRequest *)request
{
    [self switchNetworkActivityIndicatorVisibleTo:NO];
}

#define DELETE_DEVICE_URL @"http://app.njut.org.cn/timetable/deletedeviceinfo.action"

- (void)startConnectionWithPostDeviceType:(NSString *)deviceType userName:(NSString *)userName
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:DELETE_DEVICE_URL]];
    [request setPostValue:deviceType forKey:@"deviceType"];
    [request setPostValue:userName forKey:@"username"];
    [request setRequestMethod:@"POST"];
    request.delegate = self;
    request.didFinishSelector = @selector(deleteDeviceRequestDidFinishLoading:);
    request.didFailSelector = @selector(deleteDeviceRequestDidFail:);
    request.timeOutSeconds = 10;
    [request startAsynchronous];
    [self switchNetworkActivityIndicatorVisibleTo:YES];
}

- (void)switchNetworkActivityIndicatorVisibleTo:(BOOL)boolean
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = boolean;
}

- (void)logout
{
    // Clear NSUserDefaults
    //NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSError *error;
    // Cancel local notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Clear cookie jar
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *avatarPath = [paths objectAtIndex:0];
    BOOL avatarExists = [[NSFileManager defaultManager] fileExistsAtPath:[avatarPath stringByAppendingPathComponent:@"avatar.png"]];
    if (avatarExists) {
        BOOL avatarSuccess = [[NSFileManager defaultManager] removeItemAtPath:[avatarPath stringByAppendingPathComponent:@"avatar.png"] error:&error];
        if (!avatarSuccess) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
    
    // Delete Documents
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask] lastObject];
    NSURL *userUrl = [url URLByAppendingPathComponent:@"Teacher Document"];
    NSURL *calendarUrl = [url URLByAppendingPathComponent:@"Calendar Document"];
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
                    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:nil];
                } else if (!calendarSuccess) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogined"];
                [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:nil];
            }
        } else if (!userSuccess) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    } else {
        if (calendarFileExists) {
            BOOL calendarSuccess = [[NSFileManager defaultManager] removeItemAtPath:[calendarUrl path] error:&error];
            if (calendarSuccess) {
                [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:nil];
            } else if (!calendarSuccess) {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogined"];
            [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Modify Password"]) {
        if ([segue.destinationViewController isKindOfClass:[ModifyPasswordViewController class]]) {
            ModifyPasswordViewController *modifyPwdVC = [[ModifyPasswordViewController alloc] init];
            modifyPwdVC = segue.destinationViewController;
            modifyPwdVC.delegate = self;
        }
    } else if ([segue.identifier isEqualToString:@"Feedback"]) {
        if ([segue.destinationViewController isKindOfClass:[FeedbackViewController class]]) {
            FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
            feedbackVC = segue.destinationViewController;
            feedbackVC.delegate = self;
        }
    } else if ([segue.identifier isEqualToString:@"About Us"]) {
        if ([segue.destinationViewController isKindOfClass:[AboutViewController class]]) {
            AboutViewController *aboutVC = [[AboutViewController alloc] init];
            aboutVC = segue.destinationViewController;
            aboutVC.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.tableView.backgroundColor = [UIColor colorWithHue:33/360 saturation:0.05 brightness:0.93 alpha:1];
    //self.tableView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.88 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    self.groupOneCellOne.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"teacherName"] description];
    self.groupOneCellTwo.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"personnelNumber"] description];
}

@end
