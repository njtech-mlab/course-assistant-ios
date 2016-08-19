//
//  GradeTableViewCell.h
//  课程助理
//
//  Created by Jason J on 13-5-29.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GradeTableViewCell;

@protocol GradeTableViewCellDelegate <NSObject>
- (void)gradeTableViewCell:(GradeTableViewCell *)sender didRemoveCellOfIndex:(NSInteger)index;
- (void)gradeTableViewCell:(GradeTableViewCell *)sender didAddBackCellOfIndex:(NSInteger)index;
@end

@interface GradeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *coursePropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *makeupLabel;
@property (weak, nonatomic) IBOutlet UILabel *retakeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sep;
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL isRemoved;
@property (weak, nonatomic) id <GradeTableViewCellDelegate> delegate;

@end
