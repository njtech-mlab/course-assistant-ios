//
//  AboutViewController.m
//  南工评教
//
//  Created by Jason J on 13-5-4.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "AboutViewController.h"
#import "CalendarToolbar.h"
#import "UIBarButtonItem+Custom.h"

@interface AboutViewController () <UIToolbarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *aboutUsLabel;
@property (weak, nonatomic) IBOutlet CalendarToolbar *calendarToolbar;
@property (weak, nonatomic) IBOutlet UIImageView *mlabImageView;
@end

@implementation AboutViewController

- (void)cancelPresenting
{
    [self.delegate willDismissAboutViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        self.calendarToolbar.frame = CGRectMake(0, 20, 320, 44);
        self.aboutUsLabel.frame = CGRectMake(111, 29, 98, 25);
        self.mlabImageView.frame = CGRectMake(100, 64, 220, 165);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendarToolbar.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    
    UIImage *barButtonImage = [UIImage imageNamed:@"toolbar_item_icon_cancel.png"];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] init];
    cancel = [UIBarButtonItem barItemWithImage:barButtonImage
                                        target:self
                                        action:@selector(cancelPresenting)
                                    edgeInsets:UIEdgeInsetsZero
                                         width:barButtonImage.size.width
                                        height:barButtonImage.size.height];
    self.calendarToolbar.items = [NSArray arrayWithObjects:cancel, nil];
}

@end
