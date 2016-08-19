//
//  StreamTableViewCell.h
//  课程助理
//
//  Created by Jason J on 10/2/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamEvaluationButton.h"

@interface StreamTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *avatarBg;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UIView *topImageLine;


@property (weak, nonatomic) IBOutlet UIView *contentBg;
@property (weak, nonatomic) IBOutlet UILabel *likeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *starDiscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet StreamEvaluationButton *up;

@end
