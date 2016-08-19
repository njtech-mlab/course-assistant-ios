//
//  CalendarAppDelegate.m
//  Syllabus
//
//  Created by Jason J on 13-3-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CalendarAppDelegate.h"
#import "UIDevice-Hardware.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MenuTVC.h"

@interface CalendarAppDelegate() <ASIHTTPRequestDelegate>

@end

@implementation CalendarAppDelegate

@synthesize calendarDocument = _calendarDocument;
@synthesize notificationDocument = _notificationDocument;

- (void)openCalendarDocument:(void (^)(BOOL))completion
{
    __block BOOL finished = NO;
    NSURL *calendarUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                 inDomains:NSUserDomainMask] lastObject];
    calendarUrl = [calendarUrl URLByAppendingPathComponent:@"Calendar Document"];
    UIManagedDocument *document = nil;
    document = [[UIManagedDocument alloc] initWithFileURL:calendarUrl];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[calendarUrl path]]) {
        if (document.documentState == UIDocumentStateClosed) {
            [document openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    finished = YES;
                    self.calendarDocument = document;
                    completion(finished);
                } else {
                    finished = NO;
                    completion(finished);
                }
            }];
        } else if (document.documentState == UIDocumentStateNormal) {
            finished = YES;
            self.calendarDocument = document;
            completion(finished);
        } else {
            finished = NO;
            completion(finished);
        }
    } else {
        finished = NO;
        completion(finished);
    }
}

- (void)openNotificationDocument:(void (^)(BOOL))completion
{
    __block BOOL finished = NO;
    NSURL *notificationUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                     inDomains:NSUserDomainMask] lastObject];
    notificationUrl = [notificationUrl URLByAppendingPathComponent:@"Notification Document"];
    UIManagedDocument *document = nil;
    document = [[UIManagedDocument alloc] initWithFileURL:notificationUrl];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[notificationUrl path]]) {
        if (document.documentState == UIDocumentStateClosed) {
            [document openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    finished = YES;
                    self.notificationDocument = document;
                    completion(finished);
                } else {
                    finished = NO;
                    completion(finished);
                }
            }];
        }
    }
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
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //self.backgroundColor = [UIColor colorWithHue:210.0/360.0 saturation:0.9 brightness:0.7 alpha:1];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar_bg_ios6"] forBarMetrics:UIBarMetricsDefault];
        UIImage *backButtonImage = [[UIImage imageNamed:@"toolbar_button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 8)];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{ UITextAttributeTextShadowColor : [UIColor clearColor] } forState:UIControlStateNormal];
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:139.0/255.0 green:149.0/255.0 blue:222.0/255.0 alpha:1]];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHue:225.0/360.0 saturation:1.0 brightness:0.8 alpha:0.5]];
    }
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor] }];
    
    application.applicationIconBadgeNumber = 0;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"systemNotificationSwitchIsOff"]) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
        application.applicationIconBadgeNumber = 0;
    }
    NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (dictionary != nil) {
        //MenuTVC *menuTVC = [[MenuTVC alloc] init];
        //[menuTVC displayNewMessageBadge];
        //self.content = [NSString stringWithFormat:@"%@", [[dictionary objectForKey:@"aps"] objectForKey:@"alert"]];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [deviceToken description];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRegisterForRemoteNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"]) {
        [self startConnectionWithPostDeviceType:@"iOS" deviceToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] systemVersion:[NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].platformString, [UIDevice currentDevice].systemVersion]];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration. Error: %@", error);
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRegisterForRemoteNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    //MenuTVC *menuTVC = [[MenuTVC alloc] init];
    //[menuTVC displayNewMessageBadge];
    //self.content = [NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    NSLog(@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"receiveLocalNotification");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
