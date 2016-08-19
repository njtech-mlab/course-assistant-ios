//
//  GradeTableViewCell.m
//  课程助理
//
//  Created by Jason J on 13-5-29.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "GradeTableViewCell.h"

@interface GradeTableViewCell() <UIGestureRecognizerDelegate>

@end

@implementation GradeTableViewCell

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleGesture:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self.superview];
    CGFloat originalCenterY = self.center.y;
    CGPoint decreaseTranslationCenter = self.center;
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (translation.x < -90) {
            decreaseTranslationCenter.x = 160 - ((160 + (-translation.x - 60) * ((1280 + translation.x - 60) / 1280)) - 160);
            self.center = decreaseTranslationCenter;
        } else {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = CGPointMake(160, originalCenterY);
            } completion:nil];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (!self.isRemoved) {
            if (translation.x < -90) {
                for (UIView *view in [self.contentView subviews]) {
                    if (view.frame.size.height == 1 && view.tag != 1) {
                        [view removeFromSuperview];
                    }
                }
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(-300, 15, 300, 1)];
                line.backgroundColor = [UIColor whiteColor];
                [self.contentView addSubview:line];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.center = CGPointMake(160, originalCenterY);
                    self.contentView.alpha = 0.5;
                } completion:nil];
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    line.center = CGPointMake(160, 15);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self.delegate gradeTableViewCell:self didRemoveCellOfIndex:self.index];
                        self.isRemoved = YES;
                    }
                }];
            } else if (translation.x <= 0 && translation.x >= -90) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.alpha = 1;
                    self.contentView.alpha = 1;
                    self.center = CGPointMake(160, originalCenterY);
                } completion:nil];
            }
        } else {
            if (translation.x < -90) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.center = CGPointMake(160, originalCenterY);
                    self.contentView.alpha = 1;
                } completion:nil];
                for (UIView *view in [self.contentView subviews]) {
                    if (view.frame.size.height == 1 && view.tag != 1) {
                        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            view.center = CGPointMake(-300, 15);
                        } completion:^(BOOL finished) {
                            if (finished) {
                                [view removeFromSuperview];
                                [self.delegate gradeTableViewCell:self didAddBackCellOfIndex:self.index];
                                self.isRemoved = NO;
                            }
                        }];
                    }
                }
            } else if (translation.x <= 0 && translation.x >= -90) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.center = CGPointMake(160, originalCenterY);
                } completion:nil];
            }
        }
    }
}

- (void)setup
{
    UIPanGestureRecognizer *panGestureToLeft = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    panGestureToLeft.maximumNumberOfTouches = 1;
    panGestureToLeft.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:panGestureToLeft];
    panGestureToLeft.delegate = self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
