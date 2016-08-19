//
//  NJUTEventsCDTVC.m
//  云知易课堂
//
//  Created by Jason J on 13-4-11.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "NJUTEventsCDTVC.h"
#import "EvaluationTVC.h"

@interface NJUTEventsCDTVC () <EvaluationTableViewControllerDelegate>

@end

@implementation NJUTEventsCDTVC

- (IBAction)evaluationButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"Show Detail" sender:self];
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
    if ([segue.identifier isEqualToString:@"Show Detail"]) {
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
