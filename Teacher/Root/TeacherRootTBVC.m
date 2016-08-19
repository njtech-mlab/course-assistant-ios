//
//  TeacherRootTBVC.m
//  课程助理
//
//  Created by Jason J on 2/11/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "TeacherRootTBVC.h"

@interface TeacherRootTBVC ()

@end

@implementation TeacherRootTBVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UITabBarItem *streamItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:0];
    UITabBarItem *notificationItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:1];
    UITabBarItem *settingItem = (UITabBarItem *)[self.tabBar.items objectAtIndex:2];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg_ios6"]];
        self.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
        [streamItem setTitleTextAttributes:@{ UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextColor : [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1] } forState:UIControlStateNormal];
        [streamItem setTitleTextAttributes:@{ UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextColor : [UIColor colorWithRed:0 green:123.0/255.0 blue:243.0/255.0 alpha:1] } forState:UIControlStateSelected];
        [notificationItem setTitleTextAttributes:@{ UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextColor : [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1] } forState:UIControlStateNormal];
        [notificationItem setTitleTextAttributes:@{ UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextColor : [UIColor colorWithRed:0 green:123.0/255.0 blue:243.0/255.0 alpha:1] } forState:UIControlStateSelected];
        [settingItem setTitleTextAttributes:@{ UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextColor : [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1] } forState:UIControlStateNormal];
        [settingItem setTitleTextAttributes:@{ UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextColor : [UIColor colorWithRed:0 green:123.0/255.0 blue:243.0/255.0 alpha:1] } forState:UIControlStateSelected];
        [streamItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_star_icon_blue_ios6"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_star_icon_gray_ios6"]];
        [notificationItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_message_icon_blue_ios6"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_message_icon_gray_ios6"]];
        [settingItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_setting_icon_blue_ios6"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_setting_icon_gray_ios6"]];
    } else {
        streamItem.image = [UIImage imageNamed:@"tab_star_icon"];
        notificationItem.image = [UIImage imageNamed:@"tab_message_icon"];
        settingItem.image = [UIImage imageNamed:@"tab_setting_icon"];
    }
}

@end
