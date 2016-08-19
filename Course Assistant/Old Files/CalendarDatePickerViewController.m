//
//  CalendarDatePickerViewController.m
//  课程助理
//
//  Created by Jason J on 13-5-27.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CalendarDatePickerViewController.h"

@interface CalendarDatePickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *datePickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) NSInteger selectedYear;
@property (nonatomic) NSInteger selectedMonth;
@property (nonatomic) NSInteger firstYear;
@end

@implementation CalendarDatePickerViewController

- (IBAction)cancelPick:(UIButton *)sender
{
    [self.delegate cancelPick];
}

- (IBAction)donePick:(UIButton *)sender
{
    [self.delegate donePickWithYear:self.selectedYear andMonth:self.selectedMonth];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([[pickerView subviews] count] == 8) {
        UIView *pickerBackground = [[UIView alloc] initWithFrame:CGRectMake(-12, 0, 266, 216)];
        [pickerBackground setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"datepicker_background.png"]]];
        [pickerBackground.layer setCornerRadius:6.0];
        [[[pickerView subviews] objectAtIndex:1] addSubview:pickerBackground];
        
        [(UIView*)[[pickerView subviews] objectAtIndex:0] setHidden:YES];
        [(UIView*)[[pickerView subviews] objectAtIndex:4] setHidden:YES];
        [(UIView*)[[pickerView subviews] objectAtIndex:7] setHidden:YES];
    }

    if (component == 0) {
        NSInteger firstYear = [[[NSUserDefaults standardUserDefaults] objectForKey:@"grade"] integerValue];
        NSInteger rows = firstYear - 1902 + 5;
        return rows;
    } else {
        return 12;
    }
}

#define PICKER_FONT_SIZE 20.0

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *yearString = [[NSString alloc] init];
    NSString *monthString = [[NSString alloc] init];
    /*
    NSInteger firstYear = [[[NSUserDefaults standardUserDefaults] objectForKey:@"grade"] integerValue];
    if (!firstYear) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekCalendarUnit;
        NSDate *date = [NSDate date];
        comps = [gregorian components:unitFlags fromDate:date];
        firstYear = comps.year - 1;
    }
    */
    yearString = [NSString stringWithFormat:@"%d年", 1902 + row];
    monthString = [NSString stringWithFormat:@"%d月", row + 1];
    
    UIFont *font = [UIFont systemFontOfSize:PICKER_FONT_SIZE];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIColor *fontColor = [UIColor whiteColor];

    NSAttributedString *yearAttributedString = [[NSAttributedString alloc] initWithString:yearString attributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : fontColor, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    NSAttributedString *monthAttributedString = [[NSAttributedString alloc] initWithString:monthString attributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : fontColor, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    
    if (component == 0) {
        return yearAttributedString;
    } else {
        return monthAttributedString;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSAttributedString *title = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    NSString *yearString;
    NSString *monthString;
    if (component == 0) {
        yearString = title.string;
        self.selectedYear = [yearString integerValue];
    } else {
        monthString = title.string;
        self.selectedMonth = [monthString integerValue];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 140;
    } else {
        return 100;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    /*
    NSInteger firstYear = [[[NSUserDefaults standardUserDefaults] objectForKey:@"grade"] integerValue];
    if (!firstYear) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekCalendarUnit;
        NSDate *date = [NSDate date];
        comps = [gregorian components:unitFlags fromDate:date];
        firstYear = comps.year - 1;
    }
    */
    [self.datePickerView selectRow:(self.year - 1902) inComponent:0 animated:NO];
    [self.datePickerView selectRow:(self.month - 1) inComponent:1 animated:NO];
}

- (void)viewDidLoad
{
    self.datePickerView.delegate = self;
    self.datePickerView.dataSource = self;
    
    [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"popover_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"popover_button_pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"popover_button_default.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"popover_button_default_pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
}

@end
