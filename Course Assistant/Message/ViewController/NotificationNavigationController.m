//
//  NotificationNavigationController.m
//  课程助理
//
//  Created by Jason J on 10/1/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import "NotificationNavigationController.h"
#import "ECSlidingViewController.h"
#import "NavigationViewController.h"

@interface NotificationNavigationController ()

@end

@implementation NotificationNavigationController

#define NAVIGATION_VIEW_CONTROLLER_IDENTIFIER @"Navigation"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

@end
