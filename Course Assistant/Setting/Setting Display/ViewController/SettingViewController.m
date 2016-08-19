//
//  SettingViewController.m
//  南工云课堂
//
//  Created by Jason J on 13-4-22.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTVC.h"
#import "ECSlidingViewController.h"
#import "NavigationViewController.h"
#import "CalendarToolbar.h"
#import "UIBarButtonItem+Custom.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet CalendarToolbar *toolbar;
@end

@implementation SettingViewController

- (IBAction)navButtonPressed:(UIBarButtonItem *)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Setting"]) {
        if ([segue isKindOfClass:[SettingTVC class]]) {
            SettingTVC *settingTVC = [[SettingTVC alloc] init];
            settingTVC = segue.destinationViewController;
        }
    }
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set button items on tool bar
    /*
    UIImage *barButtonImage = [UIImage imageNamed:@"toolbar_nav_icon.png"];
    UIImage *navBarButtonHighlightedImage = [UIImage imageNamed:@"toolbar_nav_icon_highlighted.png"];
    UIBarButtonItem *nav = [[UIBarButtonItem alloc] init];
    nav = [UIBarButtonItem barItemWithImage:barButtonImage
                                     target:self
                                     action:@selector(navButtonPressed:)
                                 edgeInsets:UIEdgeInsetsZero
                                      width:barButtonImage.size.width
                                     height:barButtonImage.size.height
                           highlightedImage:navBarButtonHighlightedImage];
    self.toolbar.items = [NSArray arrayWithObjects:nav, nil];
    */
}

@end
