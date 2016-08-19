//
//  FeedbackViewController.h
//  课程助理
//
//  Created by Jason J on 10/15/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedbackViewController;

@protocol FeedbackViewControllerDelegate <NSObject>
- (void)willDismissFeedbackViewController;
@end

@interface FeedbackViewController : UIViewController

@property (weak, nonatomic) id <FeedbackViewControllerDelegate> delegate;

@end
