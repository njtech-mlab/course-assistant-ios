//
//  GradeDatePickerViewController.h
//  课程助理
//
//  Created by Jason J on 13-5-28.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GradeDatePickerViewController;

@protocol GradeDatePickerViewControllerDelegate <NSObject>
- (void)cancelPick;
- (void)donePickWithYear:(NSString *)year andSemester:(NSInteger)semester;
@end

@interface GradeDatePickerViewController : UIViewController

@property (weak, nonatomic) id <GradeDatePickerViewControllerDelegate> delegate;

@end
