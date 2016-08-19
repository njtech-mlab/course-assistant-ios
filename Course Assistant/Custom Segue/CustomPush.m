//
//  CustomPush.m
//  云知易课堂
//
//  Created by Jason J on 13-4-12.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "CustomPush.h"

@implementation CustomPush

- (void)perform
{
    [self performAnimation];
}

#define ANIMATION_DURATION 0.4

- (void)performAnimation
{
    UIViewController *current = self.sourceViewController;
    UIViewController *next = self.destinationViewController;
    
    /*
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        current.view.center = CGPointMake(current.view.frame.size.width / 2, 2 * current.view.frame.size.height);
        current.view.transform = CGAffineTransformRotate(current.view.transform, 10*M_PI/360);
    } completion:^(BOOL finished) {
        if (finished) {
            [current presentViewController:next animated:NO completion:nil];
        }
    }];
    */
    
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        current.view.center = CGPointMake(current.view.frame.size.width / 2, 568);
    } completion:^(BOOL finished) {
        if (finished) {
            [current presentViewController:next animated:NO completion:nil];
        }
    }];
}

@end
