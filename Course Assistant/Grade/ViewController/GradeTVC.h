//
//  GradeTVC.h
//  课程助理
//
//  Created by Jason J on 13-5-28.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GradeTVC;

@protocol GradeTVCDelegate <NSObject>
- (void)gradeTVCDidRefresh:(GradeTVC *)sender;
@end

@interface GradeTVC : UITableViewController

@property (weak, nonatomic) id <GradeTVCDelegate> delegate;
@property (strong, nonatomic) NSArray *scoreArray;

@property (nonatomic) BOOL publicCourseFilterOn;
@property (nonatomic) BOOL fourPointFilterOn;

@end
