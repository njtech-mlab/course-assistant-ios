//
//  CustomModel.m
//  课程助理
//
//  Created by Jason J on 13-7-29.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CustomModal.h"

@implementation CustomModal

- (void)perform
{
    [self performAnimation];
}

#define ANIMATION_DURATION 0.3

- (void)performAnimation
{
    UIViewController *current = self.sourceViewController;
    UIViewController *next = self.destinationViewController;
    
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        current.view.superview.superview.superview.superview.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [current presentViewController:next animated:YES completion:^{
            current.view.superview.superview.superview.superview.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } completion:nil];
}

@end
