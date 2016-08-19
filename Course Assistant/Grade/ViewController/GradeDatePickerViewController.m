//
//  GradeDatePickerViewController.m
//  课程助理
//
//  Created by Jason J on 13-5-28.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GradeDatePickerViewController.h"

@interface GradeDatePickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *gradeDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSString *selectedYear;
@property (nonatomic) NSInteger selectedSemester;
@end

@implementation GradeDatePickerViewController

- (IBAction)cancelPick:(UIButton *)sender
{
    [self.delegate cancelPick];
}

- (IBAction)donePick:(UIButton *)sender
{
    [self.delegate donePickWithYear:self.selectedYear andSemester:self.selectedSemester];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        if ([[pickerView subviews] count] == 8) {
            UIView *pickerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
            [pickerBackground setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"datepicker_background_ios6.png"]]];
            [[[pickerView subviews] objectAtIndex:1] addSubview:pickerBackground];
            
            [(UIView*)[[pickerView subviews] objectAtIndex:0] setHidden:YES];
            [(UIView*)[[pickerView subviews] objectAtIndex:3] setHidden:YES];
            [(UIView*)[[pickerView subviews] objectAtIndex:4] setHidden:YES];
            [(UIView*)[[pickerView subviews] objectAtIndex:6] setHidden:YES];
            [(UIView*)[[pickerView subviews] objectAtIndex:7] setHidden:YES];
        }
    }
    if (component == 0) {
        return 6;
    } else {
        return 3;
    }
}

#define PICKER_FONT_SIZE 17.0

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *yearString = [[NSString alloc] init];
    NSString *semesterString = [[NSString alloc] init];
    
    NSInteger firstYear = [[[NSUserDefaults standardUserDefaults] objectForKey:@"grade"] integerValue];
    if (row == 0) {
        yearString = @"所有学年";
    } else {
        yearString = [NSString stringWithFormat:@"%d-%d", firstYear + row - 1, firstYear + row];
    }
    
    if (row == 0) {
        semesterString = @"所有学期";
    } else if (row == 1) {
        semesterString = @"第一学期";
    } else if (row == 2) {
        semesterString = @"第二学期";
    }
    
    UIFont *font = [UIFont systemFontOfSize:PICKER_FONT_SIZE];
    NSMutableParagraphStyle *centerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    centerParagraphStyle.alignment = NSTextAlignmentCenter;
    UIColor *fontColor = [UIColor blackColor];
    
    NSAttributedString *yearAttributedString = [[NSAttributedString alloc] initWithString:yearString];
    NSAttributedString *semesterAttributedString = [[NSAttributedString alloc] initWithString:semesterString];
    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        yearAttributedString = [[NSAttributedString alloc] initWithString:yearString attributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : centerParagraphStyle, NSForegroundColorAttributeName : fontColor, NSBackgroundColorAttributeName : [UIColor clearColor] }];
        semesterAttributedString = [[NSAttributedString alloc] initWithString:semesterString attributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : centerParagraphStyle, NSForegroundColorAttributeName : fontColor, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    }
    
    if (component == 0) {
        return yearAttributedString;
    } else {
        return semesterAttributedString;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = [self pickerView:pickerView attributedTitleForRow:row forComponent:component].string;
    NSString *yearString;
    NSString *semesterString;
    if (component == 0) {
        yearString = title;
        self.selectedYear = yearString;
    } else {
        semesterString = title;
        if ([semesterString isEqualToString:@"第一学期"]) {
            self.selectedSemester = 1;
        } else if ([semesterString isEqualToString:@"第二学期"]) {
            self.selectedSemester = 2;
        } else if ([semesterString isEqualToString:@"所有学期"]) {
            self.selectedSemester = 3;
        } else {
            self.selectedSemester = 3;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 160;
    } else {
        return 160;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gradeDatePicker.delegate = self;
    self.gradeDatePicker.dataSource = self;
    
    if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
        UIView *upperLine = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320, 1)];
        UIView *lowerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 1)];
        upperLine.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1];
        lowerLine.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1];
        [self.view addSubview:upperLine];
        [self.view addSubview:lowerLine];        
    }
}

@end
