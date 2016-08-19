//
//  SettingTVC.m
//  南工评教
//
//  Created by Jason J on 13-4-25.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "SettingTVC.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ECSlidingViewController.h"
#import "ModifyPasswordViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "UIBarButtonItem+Custom.h"

@interface SettingTVC () <ModifyPasswordViewControllerDelegate, AboutViewControllerDelegate, FeedbackViewControllerDelegate, UITableViewDelegate, UIActionSheetDelegate, ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *group1Cell5;
@property (weak, nonatomic) IBOutlet UITableViewCell *group1Cell4;
@property (weak, nonatomic) IBOutlet UITableViewCell *group1Cell3;
@property (weak, nonatomic) IBOutlet UITableViewCell *group1Cell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *group1Cell1;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cellGropTwo;
@property (weak, nonatomic) IBOutlet UISwitch *systemNotificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *GPAGeniusSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *feedbackCell;
@property (weak, nonatomic) UIActionSheet *logoutActionSheet;
@end

@implementation SettingTVC

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
#define SEGUE_IDENTIFIER @"Logout"

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
    NSURL *userUrl = [url URLByAppendingPathComponent:@"Student Document"];
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

- (IBAction)navButtonPressed:(UIBarButtonItem *)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)switchAction:(UISwitch *)sender
{
    if ([sender isEqual:self.systemNotificationSwitch]) {
        if (!sender.on) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
        }
        [[NSUserDefaults standardUserDefaults] setBool:(!sender.on) forKey:@"systemNotificationSwitchIsOff"];
    } else if ([sender isEqual:self.GPAGeniusSwitch]) {
        if (sender.on) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GPAGeniusSwitch"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GPAGeniusSwitch"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    self.tableView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    
    self.group1Cell1.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"studentName"] description];
    self.group1Cell2.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faculty"] description];
    self.group1Cell3.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"major"] description];
    self.group1Cell4.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"naturalClass"] description];
    self.group1Cell5.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"district"] description];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.systemNotificationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.GPAGeniusSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GPAGeniusSwitch"]) {
        self.GPAGeniusSwitch.on = YES;
    } else {
        self.GPAGeniusSwitch.on = NO;
    }
    
    self.navigationController.navigationBar.titleTextAttributes = @{ UITextAttributeFont : [UIFont systemFontOfSize:17.0], UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero] };
    
    UIImage *barButtonImage = [UIImage imageNamed:@"toolbar_nav_icon.png"];
    UIBarButtonItem *nav = [[UIBarButtonItem alloc] init];
    nav = [UIBarButtonItem barItemWithImage:barButtonImage
                                     target:self
                                     action:@selector(navButtonPressed:)
                                 edgeInsets:UIEdgeInsetsZero
                                      width:barButtonImage.size.width
                                     height:barButtonImage.size.height];
    self.navigationItem.leftBarButtonItem = nav;
}

@end
