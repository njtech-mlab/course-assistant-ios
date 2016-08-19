//
//  EvaluationTVC.h
//  南工评教
//
//  Created by Jason J on 13-5-2.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EvaluationTVC;

@protocol EvaluationTableViewControllerDelegate <NSObject>
@optional
- (void)willDismissEventDetailViewController;
@end

@interface EvaluationTVC : UITableViewController

@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *teacherName;
@property (strong, nonatomic) NSString *courseProperty;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *ctid;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (weak, nonatomic) id <EvaluationTableViewControllerDelegate> delegate;

@end
