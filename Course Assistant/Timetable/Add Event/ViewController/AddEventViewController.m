//
//  AddEventViewController.m
//  课程助理
//
//  Created by Jason J on 13-7-29.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "AddEventViewController.h"
#import "CalendarToolbar.h"
#import "UIBarButtonItem+Custom.h"

@interface AddEventViewController ()
@property (weak, nonatomic) IBOutlet CalendarToolbar *calendarToolbar;
@end

@implementation AddEventViewController

- (void)cancelPresenting
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)donePresenting
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIImage *barCancelButtonImage = [UIImage imageNamed:@"toolbar_item_icon_cancel.png"];
    UIImage *barConfirmButtonImage = [UIImage imageNamed:@"toolbar_item_icon_confirm.png"];
    UIImage *barCancelButtonHighlightedImage = [UIImage imageNamed:@"toolbar_item_icon_cancel_highlighted.png"];
    UIImage *barConfirmButtonHighlightedImage = [UIImage imageNamed:@"toolbar_item_icon_confirm_highlighted.png"];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] init];
    cancel = [UIBarButtonItem barItemWithImage:barCancelButtonImage
                                        target:self
                                        action:@selector(cancelPresenting)
                                    edgeInsets:UIEdgeInsetsZero
                                         width:barCancelButtonImage.size.width
                                        height:barCancelButtonImage.size.height
                              highlightedImage:barCancelButtonHighlightedImage];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] init];
    done = [UIBarButtonItem barItemWithImage:barConfirmButtonImage
                                      target:self
                                      action:@selector(donePresenting)
                                  edgeInsets:UIEdgeInsetsZero
                                       width:barConfirmButtonImage.size.width
                                      height:barConfirmButtonImage.size.height
                            highlightedImage:barConfirmButtonHighlightedImage];
    UIBarButtonItem *measurement = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.calendarToolbar.items = [NSArray arrayWithObjects:cancel, measurement, done, nil];
}

@end
