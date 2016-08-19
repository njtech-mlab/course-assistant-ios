//
//  CalendarTableViewCell.h
//  Syllabus
//
//  Created by Jason J on 13-3-29.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classroomLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;

@end
