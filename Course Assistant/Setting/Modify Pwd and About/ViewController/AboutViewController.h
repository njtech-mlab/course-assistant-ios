//
//  AboutViewController.h
//  南工评教
//
//  Created by Jason J on 13-5-4.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AboutViewController;

@protocol AboutViewControllerDelegate <NSObject>
- (void)willDismissAboutViewController;
@end

@interface AboutViewController : UIViewController

@property (weak, nonatomic) id <AboutViewControllerDelegate> delegate;

@end
