//
//  StreamEvaluationButton.h
//  课程助理
//
//  Created by Jason J on 10/4/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamEvaluationButton : UIButton

// Like and Comment
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *resultNumberLabel;
@property (strong, nonatomic) StreamEvaluationButton *oppositeBtn;
@property (strong, nonatomic) UILabel *oppositeDescriptionLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic) NSInteger numberOfStreams;
@property (nonatomic) NSInteger numberOfLikes;

@property (strong, nonatomic) NSString *edid;
@property (strong, nonatomic) NSString *schoolNumber;

// Evaluation
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *teacherName;
@property (strong, nonatomic) NSString *courseProperty;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *ctid;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;

@end
