//
//  NJUTListEventsCDTVC.m
//  南工课立方
//
//  Created by Jason J on 13-5-9.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "NJUTListEventsCDTVC.h"
#import "EvaluationTVC.h"

@interface NJUTListEventsCDTVC () <EvaluationTableViewControllerDelegate>

@end

@implementation NJUTListEventsCDTVC

- (IBAction)evaluationButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"L Show Detail" sender:self];
}

- (IBAction)summaryButtonPressed:(id)sender
{
    [self.delegate displaySummaryViewWithCtid:self.ctid andStartTime:self.startTime];
}

- (void)willDismissEventDetailViewController
{
    self.view.superview.superview.superview.superview.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.superview.superview.superview.superview.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"L Show Detail"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
            if ([navigationController.topViewController isKindOfClass:[EvaluationTVC class]]) {
                EvaluationTVC *evaluationTVC;
                evaluationTVC = (EvaluationTVC *)navigationController.topViewController;
                evaluationTVC.delegate = self;
                evaluationTVC.courseName = self.courseName;
                evaluationTVC.courseProperty = self.courseProperty;
                evaluationTVC.credit = self.credit;
                evaluationTVC.ctid = self.ctid;
                evaluationTVC.startTime = self.startTime;
                evaluationTVC.endTime = self.endTime;
                evaluationTVC.teacherName = self.teacherName;
            }
        }
    }
}

@end
