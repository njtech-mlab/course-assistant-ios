//
//  MenuTVC.m
//  Syllabus
//
//  Created by Jason J on 13-3-31.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "MenuTVC.h"
#import "CalendarViewController.h"
#import "ASIHTTPRequest.h"
#import "UIManagedDocumentHandler.h"
#import "ECSlidingViewController.h"
#import "MenuTableViewCell.h"
#import "UserInfoFetcher.h"
#import "CalendarDataFetcher.h"
#import "User+NJTech.h"
#import "Course+NJTech.h"

@interface MenuTVC () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *menuItemBg1;
@property (weak, nonatomic) IBOutlet UIImageView *menuItemBg2;
@property (weak, nonatomic) IBOutlet UIImageView *menuItemBg3;
@property (weak, nonatomic) IBOutlet UIImageView *menuItemBg4;
@property (weak, nonatomic) IBOutlet UIImageView *menuItemBg5;
@property (strong, nonatomic) NSArray *menuItems;
@property (weak, nonatomic) IBOutlet MenuTableViewCell *messageCell;
@property (weak, nonatomic) IBOutlet UIImageView *messageIcon;
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *updateIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *updateSpinner;
@property (weak, nonatomic) IBOutlet UIImageView *timetableImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UIImageView *settingImageView;
@property (weak, nonatomic) NSTimer *backgroundTimer;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) NSArray *calendarData;
@property (strong, nonatomic) NSManagedObjectContext *userManagedObjectContext;
@property (weak, nonatomic) id <UIManagedDocumentHandlerDelegate> managedDocumentHandlerDelegate;
@property (strong, nonatomic) CalendarViewController *calendarVC;
@property (nonatomic) BOOL isSelected;
@end

@implementation MenuTVC

- (CalendarViewController *)calendarVC
{
    if (!_calendarVC) {
        _calendarVC = [[CalendarViewController alloc] init];
    }
    return _calendarVC;
}

- (id <UIManagedDocumentHandlerDelegate>)managedDocumentHandlerDelegate
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if(!_managedDocumentHandlerDelegate && [appDelegate conformsToProtocol: @protocol(UIManagedDocumentHandlerDelegate)]) {
        return appDelegate;
    }
    return _managedDocumentHandlerDelegate;
}

- (void)switchNetworkActivityIndicatorVisibleTo:(BOOL)boolean
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = boolean;
}

- (void)saveCalendarDataToCoreData
{
    [self.managedDocumentHandlerDelegate.calendarDocument.managedObjectContext performBlock:^{
        for (NSDictionary *course in self.calendarData) {
            [Course courseWithInfo:course inManagedContext:self.managedDocumentHandlerDelegate.calendarDocument.managedObjectContext];
        }
    }];
    self.updateIcon.hidden = NO;
    self.updateSpinner.hidden = YES;
    [self.updateSpinner stopAnimating];
    self.calendarVC.managedObjectContext = self.managedDocumentHandlerDelegate.calendarDocument.managedObjectContext;
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void)saveUserDataToCoreData
{
    [self.userManagedObjectContext performBlock:^{
        [User userWithInfo:self.userInfo inManagedContext:self.userManagedObjectContext];
    }];
}

- (void)updateCalendarDocument
{
    NSURL *calendarUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                 inDomains:NSUserDomainMask] lastObject];
    calendarUrl = [calendarUrl URLByAppendingPathComponent:@"Calendar Document"];
    UIManagedDocument *document = nil;
    document = [[UIManagedDocument alloc] initWithFileURL:calendarUrl];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[calendarUrl path]]) {
        [document saveToURL:calendarUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                self.managedDocumentHandlerDelegate.calendarDocument = document;
                [self saveCalendarDataToCoreData];
            }
        }];
    } else {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[calendarUrl path] error:&error];
        if (success) {
            [self updateCalendarDocument];
        } else if (!success) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
}

- (void)updateUserDocument
{
    NSURL *userUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
    userUrl = [userUrl URLByAppendingPathComponent:@"Student Document"];
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
            [self updateUserDocument];
        } else if (!success) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self showAlertUsingString:@"更新失败，请重试。"];
    self.updateIcon.hidden = NO;
    self.updateSpinner.hidden = YES;
    [self.updateSpinner stopAnimating];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    NSError *error = [request error];
    NSLog(@"%@", error.localizedDescription);
}

- (void)cookieRequestDidFinishLoading:(ASIHTTPRequest *)cookieRequest
{
    if ([cookieRequest responseData]) {
        self.calendarData = [CalendarDataFetcher fetchCalendarData:[cookieRequest responseData]];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
        [self updateCalendarDocument];
    } else {
        [self showAlertUsingString:@"更新失败，请重试。"];
        self.updateIcon.hidden = NO;
        self.updateSpinner.hidden = YES;
        [self.updateSpinner stopAnimating];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
    }
}

#define SYLLABUS_URL @"http://app.njut.org.cn/timetable/curriculum.action"

- (void)startConnectionWithCookie
{
    ASIHTTPRequest *cookieRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:SYLLABUS_URL]];
    cookieRequest.delegate = self;
    cookieRequest.didFinishSelector = @selector(cookieRequestDidFinishLoading:);
    [cookieRequest startAsynchronous];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    [self showAlertUsingString:@"更新失败，请重试。"];
    self.updateIcon.hidden = NO;
    self.updateSpinner.hidden = YES;
    [self.updateSpinner stopAnimating];
    [self stopBackgroundTimer];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
    NSLog(@"%@", error.localizedDescription);
    [connection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self stopBackgroundTimer];
    [self updateUserDocument];
    [connection cancel];
    [self startConnectionWithCookie];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data) {
        self.userInfo = [UserInfoFetcher fetchUserInfo:data];
    } else {
        [connection cancel];
        [self showAlertUsingString:@"更新失败，请重试。"];
        self.updateIcon.hidden = NO;
        self.updateSpinner.hidden = YES;
        [self.updateSpinner stopAnimating];
        [self switchNetworkActivityIndicatorVisibleTo:NO];
    }
}

#define USER_INFO_URL @"http://app.njut.org.cn/timetable/login.action"

- (void)startConnectingWithPostString:(NSString *)postString
{
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:USER_INFO_URL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[conn start];
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

#define TIMER_INTERVAL 15

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
    [self showAlertUsingString:@"更新失败，请重试。"];
    self.updateIcon.hidden = NO;
    self.updateSpinner.hidden = YES;
    [self.updateSpinner stopAnimating];
    [self switchNetworkActivityIndicatorVisibleTo:NO];
}

- (void)stopBackgroundTimer
{
    [self.backgroundTimer invalidate];
}

// Update button pressed
#define SYLLABUS_URL @"http://app.njut.org.cn/timetable/curriculum.action"

- (IBAction)updateButtonPressed:(UIButton *)sender
{
    self.updateIcon.hidden = YES;
    self.updateSpinner.hidden = NO;
    [self.updateSpinner startAnimating];
    [self startConnectingWithPostString:[NSString stringWithFormat:@"email=%@&password=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"], [[NSUserDefaults standardUserDefaults] valueForKey:@"password"]]];
}

- (void)resetIcon
{
    self.timetableImageView.image = [UIImage imageNamed:@"menu_calendar_icon"];
    self.gradeImageView.image = [UIImage imageNamed:@"menu_score_icon"];
    self.messageImageView.image = [UIImage imageNamed:@"menu_message_icon"];
    self.settingImageView.image = [UIImage imageNamed:@"menu_setting_icon"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuItems objectAtIndex:indexPath.row]];
    /*if ([identifier isEqualToString:@"Message"]) {
        UITableViewCell *messageCell = [tableView cellForRowAtIndexPath:indexPath];
        messageCell.contentView.alpha = 1.0;
        if (!self.isSelected) {
            messageCell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_message_selected_bg.png"]];
            self.messageIcon.image = [UIImage imageNamed:@"menu_message_icon_selected.png"];
            self.messageTitle.textColor = [UIColor colorWithHue:0 saturation:0 brightness:0.17 alpha:1];
            self.messageTitle.shadowColor = [UIColor clearColor];
            self.isSelected = YES;
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"viewAllNewMessage"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"viewAllNewMessage"];
                self.theNewMessageImageView.hidden = YES;
            }
            [self.delegate menuTVC:self didSelectMessageCell:YES];
        } else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageCell.frame.size.width, messageCell.frame.size.height)];
            view.backgroundColor = [UIColor clearColor];
            messageCell.selectedBackgroundView = view;
            messageCell.backgroundColor = [UIColor clearColor];
            messageCell.backgroundView = view;
            self.messageIcon.image = [UIImage imageNamed:@"menu_message_icon.png"];
            self.messageTitle.textColor = [UIColor whiteColor];
            self.messageTitle.shadowColor = [UIColor blackColor];
            self.isSelected = NO;
            [self.delegate menuTVC:self didSelectMessageCell:NO];
        }
    } else {
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }*/
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        if (indexPath.item == 0) {
            self.menuItemBg1.alpha = 0.15;
            self.menuItemBg2.alpha = 0;
            self.menuItemBg3.alpha = 0;
            self.menuItemBg4.alpha = 0;
            self.menuItemBg5.alpha = 0;
        } else if (indexPath.item == 1) {
            self.menuItemBg1.alpha = 0;
            self.menuItemBg2.alpha = 0.15;
            self.menuItemBg3.alpha = 0;
            self.menuItemBg4.alpha = 0;
            self.menuItemBg5.alpha = 0;
        } else if (indexPath.item == 2) {
            self.menuItemBg1.alpha = 0;
            self.menuItemBg2.alpha = 0;
            self.menuItemBg3.alpha = 0.15;
            self.menuItemBg4.alpha = 0;
            self.menuItemBg5.alpha = 0;
        } else if (indexPath.item == 3) {
            self.menuItemBg1.alpha = 0;
            self.menuItemBg2.alpha = 0;
            self.menuItemBg3.alpha = 0;
            self.menuItemBg4.alpha = 0.15;
            self.menuItemBg5.alpha = 0;
        } else if (indexPath.item == 4) {
            self.menuItemBg1.alpha = 0;
            self.menuItemBg2.alpha = 0;
            self.menuItemBg3.alpha = 0;
            self.menuItemBg4.alpha = 0;
            self.menuItemBg5.alpha = 0.15;
        }
        
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopViewWithAnimations:^{
            for (UIImageView *image in self.slidingViewController.topViewController.view.subviews) {
                if (image.tag == 14) {
                    image.alpha = 0;
                    [image removeFromSuperview];
                }
            }
        } onComplete:nil];
    }];
}

/*
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuItems objectAtIndex:indexPath.row]];
    if ([identifier isEqualToString:@"Message"]) {
        UITableViewCell *messageCell = [tableView cellForRowAtIndexPath:indexPath];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageCell.frame.size.width, messageCell.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        messageCell.selectedBackgroundView = view;
        messageCell.backgroundColor = [UIColor clearColor];
        messageCell.backgroundView = view;
        messageCell.contentView.alpha = 1.0;
        self.messageIcon.image = [UIImage imageNamed:@"menu_message_icon.png"];
        self.messageTitle.textColor = [UIColor whiteColor];
        self.messageTitle.shadowColor = [UIColor blackColor];
        self.isSelected = NO;
    }
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.updateSpinner.hidden = YES;
}

- (void)awakeFromNib
{
    self.menuItems = [NSArray arrayWithObjects:@"Stream", @"Home", @"Grade", @"Message", @"Setting", nil];
}

@end
