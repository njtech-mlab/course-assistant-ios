//
//  StreamCDTVC.m
//  课程助理
//
//  Created by Jason J on 9/19/13.
//  Copyright (c) 2013 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "StreamCDTVC.h"
#import "StreamDetailViewController.h"
#import "StreamTableViewCell.h"
#import "StreamFetcher.h"
#import "StreamRefreshControl.h"
#import "StreamEvaluationButton.h"
#import "EvaluationTextView.h"
#import "Stream+Evaluate.h"
#import "UIManagedDocumentHandler.h"
#import "UIBarButtonItem+Custom.h"

@interface StreamCDTVC ()
@property (weak, nonatomic) id <UIManagedDocumentHandlerDelegate> managedDocumentHandlerDelegate;
@property (strong, nonatomic) NSDictionary *streamsDic;
@property (strong, nonatomic) NSArray *streams;
@property (strong, nonatomic) NSMutableArray *mutableStreams;
@property (strong, nonatomic) NSMutableArray *latestStreams;
@property (strong, nonatomic) NSString *edidOfLastUpdatedStream;
@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UITableViewCell *topCell;
@property (strong, nonatomic) NSMutableArray *currentStreams;
@property (strong, nonatomic) NSMutableArray *likedStreams;
@property (strong, nonatomic) UIButton *titleSwitchButton;
@property (strong, nonatomic) UIImageView *switchArrowImage;
@property (strong, nonatomic) UIImageView *noStreamImageView;
@property (strong, nonatomic) UIImageView *noStreamArrowImageView;
@property (strong, nonatomic) UILabel *noStreamLabel;
@property (strong, nonatomic) UIView *blackView;
@property (strong, nonatomic) UIView *summaryView;
@property (strong, nonatomic) UITextView *summaryTextView;
@property (strong, nonatomic) UIButton *summaryCancelButton;
@property (strong, nonatomic) UIButton *summaryDoneButton;
@property (strong, nonatomic) NSString *summaryCtid;
@property (strong, nonatomic) NSString *summaryStartTime;
@property (nonatomic) BOOL isEvaluationStream;
@end

@implementation StreamCDTVC

@synthesize managedDocumentHandlerDelegate = _managedDocumentHandlerDelegate;

- (id <UIManagedDocumentHandlerDelegate>)managedDocumentHandlerDelegate
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if(!_managedDocumentHandlerDelegate && [appDelegate conformsToProtocol: @protocol(UIManagedDocumentHandlerDelegate)]) {
        return appDelegate;
    }
    return _managedDocumentHandlerDelegate;
}

- (NSMutableArray *)mutableStreams
{
    if (!_mutableStreams) {
        _mutableStreams = [[NSMutableArray alloc] init];
    }
    return _mutableStreams;
}

- (NSMutableArray *)likedStreams
{
    if (!_likedStreams) {
        _likedStreams = [[NSMutableArray alloc] init];
    }
    return _likedStreams;
}

- (UIButton *)titleSwitchButton
{
    if (!_titleSwitchButton) {
        _titleSwitchButton = [[UIButton alloc] init];
    }
    return _titleSwitchButton;
}

- (IBAction)upPressed:(StreamEvaluationButton *)sender
{
    sender.selected = !sender.isSelected;
    NSInteger tag;
    NSInteger originalLikes = [[[self.mutableStreams objectAtIndex:sender.numberOfStreams] objectForKey:STREAM_LIKE_NUMBER] integerValue];
    if (sender.selected) {
        [self.likedStreams addObject:[NSString stringWithFormat:@"%d", sender.numberOfStreams]];
        [[self.mutableStreams objectAtIndex:sender.numberOfStreams] setValue:@"true" forKey:STREAM_EVER_LIKE];
        sender.descriptionLabel.text = @"-1";
        sender.oppositeBtn.enabled = NO;
        sender.oppositeDescriptionLabel.alpha = 0.5;
        tag = 1;
        NSInteger currentLikes = originalLikes + 1;
        [[self.mutableStreams objectAtIndex:sender.numberOfStreams] setValue:[NSString stringWithFormat:@"%d", currentLikes] forKey:STREAM_LIKE_NUMBER];
        dispatch_queue_t fetchQ = dispatch_queue_create("Stream Like Fetch", NULL);
        dispatch_async(fetchQ, ^{
            [StreamFetcher fetchLikeResponseWithEdid:sender.edid from:[[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"] to:sender.schoolNumber tag:[NSString stringWithFormat:@"%d", tag]];
        });
    } else {
        [self.likedStreams removeObject:[NSString stringWithFormat:@"%d", sender.numberOfStreams]];
        [[self.mutableStreams objectAtIndex:sender.numberOfStreams] setValue:@"false" forKey:STREAM_EVER_LIKE];
        sender.descriptionLabel.text = @"+1";
        sender.oppositeBtn.enabled = YES;
        sender.oppositeDescriptionLabel.alpha = 1;
        tag = 0;
        NSInteger currentLikes = originalLikes - 1;
        [[self.mutableStreams objectAtIndex:sender.numberOfStreams] setValue:[NSString stringWithFormat:@"%d", currentLikes] forKey:STREAM_LIKE_NUMBER];
        dispatch_queue_t fetchQ = dispatch_queue_create("Stream Like Fetch", NULL);
        dispatch_async(fetchQ, ^{
            [StreamFetcher fetchLikeResponseWithEdid:sender.edid from:[[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"] to:sender.schoolNumber tag:[NSString stringWithFormat:@"%d", tag]];
        });
    }

    [UIView animateWithDuration:0.14 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        sender.resultNumberLabel.center = CGPointMake(sender.resultNumberLabel.center.x, sender.resultNumberLabel.center.y - 10);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.12 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                sender.resultNumberLabel.center = CGPointMake(sender.resultNumberLabel.center.x, sender.resultNumberLabel.center.y + 20);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        sender.resultNumberLabel.center = CGPointMake(sender.resultNumberLabel.center.x, sender.resultNumberLabel.center.y - 10);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            if (sender.selected) {
                                sender.resultNumberLabel.layer.borderColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1].CGColor;
                                sender.resultNumberLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                                sender.resultNumberLabel.text = [NSString stringWithFormat:@"+%d", [[[self.mutableStreams objectAtIndex:sender.numberOfStreams] objectForKey:STREAM_LIKE_NUMBER] integerValue]];
                            } else {
                                if ([[[self.mutableStreams objectAtIndex:sender.numberOfStreams] objectForKey:STREAM_LIKE_NUMBER] integerValue] == 0) {
                                    sender.resultNumberLabel.backgroundColor = [UIColor whiteColor];
                                    sender.resultNumberLabel.textColor = [UIColor lightGrayColor];
                                    sender.resultNumberLabel.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
                                    sender.resultNumberLabel.text = @"0";
                                } else if ([[[self.mutableStreams objectAtIndex:sender.numberOfStreams] objectForKey:STREAM_LIKE_NUMBER] integerValue] > 0) {
                                    sender.resultNumberLabel.layer.borderColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1].CGColor;
                                    sender.resultNumberLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
                                    sender.resultNumberLabel.text = [NSString stringWithFormat:@"+%d", [[[self.mutableStreams objectAtIndex:sender.numberOfStreams] objectForKey:STREAM_LIKE_NUMBER] integerValue]];
                                }
                            }
                        }
                    }];
                }
            }];
        }
    }];
}

- (IBAction)commentPressed:(StreamEvaluationButton *)sender
{
    [self performSegueWithIdentifier:@"Stream Detail" sender:sender.indexPath];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.mutableStreams count]) {
        return [self.mutableStreams count];
    } else {
        return [self.mutableStreams count] + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.item == [self.mutableStreams count]) {
        height = 44.0;
    } else {
        NSDictionary *stream = [self.mutableStreams objectAtIndex:indexPath.item];
        CGFloat contentHeight = 0;
        CGFloat addtionHeight = 0;
        if (self.isEvaluationStream) {
            contentHeight = [[[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(225, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                addtionHeight = 200.0;
            } else {
                addtionHeight = 190.0;
            }
        } else {
            contentHeight = [[[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(225, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
            addtionHeight = 170.0;
        }
        height = contentHeight + addtionHeight;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StreamCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.item == [self.mutableStreams count]) {
        UILabel *loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 180, 21)];
        loadMoreLabel.backgroundColor = [UIColor clearColor];
        loadMoreLabel.text = @"加载更多";
        loadMoreLabel.textAlignment = NSTextAlignmentCenter;
        loadMoreLabel.font = [UIFont systemFontOfSize:15.0];
        loadMoreLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:loadMoreLabel];        
    } else {
        NSDictionary *stream = [self.mutableStreams objectAtIndex:indexPath.item];
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *contentBg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, cell.frame.size.height - 5)];
        contentBg.image = [[UIImage imageNamed:@"stream_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 90, 10)];
        contentBg.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:contentBg];
        
        UILabel *likeNumberLabel;
        if (!self.isEvaluationStream) {
            likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
            likeNumberLabel.layer.cornerRadius = 25.0;
            likeNumberLabel.backgroundColor = [UIColor whiteColor];
            likeNumberLabel.layer.borderWidth = 1.0f;
            if ([[stream objectForKey:STREAM_LIKE_NUMBER] integerValue] == 0) {
                likeNumberLabel.textColor = [UIColor lightGrayColor];
                likeNumberLabel.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
            } else if ([[stream objectForKey:STREAM_LIKE_NUMBER] integerValue] > 0) {
                likeNumberLabel.layer.borderColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1].CGColor;
                likeNumberLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
            } else if ([[stream objectForKey:STREAM_LIKE_NUMBER] integerValue] < 0) {
                likeNumberLabel.layer.borderColor = [UIColor colorWithHue:349.0/360.0 saturation:0.77 brightness:0.86 alpha:1].CGColor;
                likeNumberLabel.textColor = [UIColor colorWithHue:349.0/360.0 saturation:0.77 brightness:0.86 alpha:1];
            }
            if (![[stream objectForKey:STREAM_LIKE_NUMBER] integerValue]) {
                likeNumberLabel.text = @"0";
            } else {
                likeNumberLabel.text = [NSString stringWithFormat:@"+%d", [[stream objectForKey:STREAM_LIKE_NUMBER] integerValue]];
            }
            likeNumberLabel.textAlignment = NSTextAlignmentCenter;
            likeNumberLabel.font = [UIFont systemFontOfSize:23.0];
            [cell.contentView addSubview:likeNumberLabel];
        }
        
        UILabel *contentLabel;
        if (!self.isEvaluationStream) {
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 270, 2008)];
        } else {
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 98, 270, 2008)];
        }
        contentLabel.backgroundColor = [UIColor clearColor];
        if (self.isEvaluationStream) {
            contentLabel.text = [[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description];
        } else {
            contentLabel.text = [[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description];
        }
        contentLabel.textColor = [UIColor darkTextColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
        [contentBg addSubview:contentLabel];
        
        UILabel *courseNameLabel;
        if (!self.isEvaluationStream) {
            courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 210, 21)];
        } else {
            courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 260, 21)];
        }
        courseNameLabel.backgroundColor = [UIColor clearColor];
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
            courseNameLabel.text = self.courseName;
        } else {
            courseNameLabel.text = [[stream objectForKey:STREAM_COURSE_NAME] description];
        }
        courseNameLabel.textColor = [UIColor darkTextColor];
        courseNameLabel.textAlignment = NSTextAlignmentLeft;
        courseNameLabel.font = [UIFont systemFontOfSize:15.0];
        [contentBg addSubview:courseNameLabel];
        
        UILabel *dateLabel;
        if (!self.isEvaluationStream) {
            dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 41, 210, 21)];
        } else {
            dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 41, 260, 21)];
        }
        dateLabel.backgroundColor = [UIColor clearColor];
        if (self.isEvaluationStream) {
            dateLabel.text = [[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_SUMMARY_INFO_TIME] description];
        } else {
            dateLabel.text = [[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_TIME] description];
        }
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.font = [UIFont systemFontOfSize:13.0];
        [contentBg addSubview:dateLabel];
        
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] > 5) {
            if (!self.isEvaluationStream) {
                UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, cell.frame.size.height - 35, 105, 21)];
                StreamEvaluationButton *up = [StreamEvaluationButton buttonWithType:UIButtonTypeCustom];
                upLabel.backgroundColor = [UIColor clearColor];
                upLabel.textAlignment = NSTextAlignmentCenter;
                upLabel.font = [UIFont boldSystemFontOfSize:12.0];
                if ([[stream objectForKey:STREAM_EVER_LIKE] isEqualToString:@"true"]) {
                    upLabel.text = @"-1";
                    up.selected = YES;
                } else {
                    if ([self.likedStreams count]) {
                        for (NSString *index in self.likedStreams) {
                            if ([index integerValue] == indexPath.item) {
                                upLabel.text = @"-1";
                                up.selected = YES;
                            } else {
                                upLabel.text = @"+1";
                                up.selected = NO;
                            }
                        }
                    } else {
                        upLabel.text = @"+1";
                        up.selected = NO;
                    }
                }
                upLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:156.0/255.0 blue:161.0/255.0 alpha:1];
                [cell.contentView addSubview:upLabel];
                UIImage *upImage = [UIImage imageNamed:@"thumb"];
                [up setBackgroundImage:upImage forState:UIControlStateNormal];
                up.frame = CGRectMake(15, cell.frame.size.height - 42, 150, 35);
                up.descriptionLabel = upLabel;
                if (!self.isEvaluationStream) {
                    up.resultNumberLabel = likeNumberLabel;
                }
                up.numberOfStreams = indexPath.item;
                up.numberOfLikes = [[stream objectForKey:STREAM_LIKE_NUMBER] integerValue];
                up.edid = [[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_INFO_EDID] description];
                up.schoolNumber = [[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_INFO_SCHOOLNUMBER] description];
                [up addTarget:self action:@selector(upPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:up];
                [cell.contentView bringSubviewToFront:upLabel];
            }
        }
        
        UILabel *commentLabel = nil;
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5 || self.isEvaluationStream) {
            commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, cell.frame.size.height - 35, 95, 21)];
        } else {
            commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, cell.frame.size.height - 35, 95, 21)];
        }
        StreamEvaluationButton *comment = [StreamEvaluationButton buttonWithType:UIButtonTypeCustom];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.textAlignment = NSTextAlignmentCenter;
        commentLabel.font = [UIFont boldSystemFontOfSize:12.0];
        commentLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:156.0/255.0 blue:161.0/255.0 alpha:1];
        commentLabel.text = @"评论";
        [cell.contentView addSubview:commentLabel];
        UIImage *commentImage = [UIImage imageNamed:@"comment"];
        [comment setBackgroundImage:commentImage forState:UIControlStateNormal];
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5 || self.isEvaluationStream) {
            comment.frame = CGRectMake(70, cell.frame.size.height - 42, 150, 35);
        } else {
            comment.frame = CGRectMake(150, cell.frame.size.height - 42, 150, 35);
        }
        comment.indexPath = indexPath;
        [comment addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:comment];
        [cell.contentView bringSubviewToFront:commentLabel];
        
        UILabel *statisticLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, cell.frame.size.height - 75, 150, 21)];
        statisticLabel.font = [UIFont boldSystemFontOfSize:12.0];
        statisticLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:156.0/255.0 blue:161.0/255.0 alpha:1];
        NSInteger numberOfComments = [[[stream objectForKey:STREAM_COMMENT] objectForKey:STREAM_COMMENT_LIST] count];
        statisticLabel.text = [NSString stringWithFormat:@"%d 条评论", numberOfComments];
        [cell.contentView addSubview:statisticLabel];
        
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] > 5) {
            UILabel *teacherReplyLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, cell.frame.size.height - 75, 150, 21)];
            teacherReplyLabel.backgroundColor = [UIColor clearColor];
            if ([[stream objectForKey:STREAM_TEACHER_REPLY_TOKEN] isEqualToString:@"true"]) {
                teacherReplyLabel.text = @"有教师评论";
            } else {
                teacherReplyLabel.text = @"";
            }
            teacherReplyLabel.textColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:80.0/255.0 alpha:1];
            teacherReplyLabel.font = [UIFont boldSystemFontOfSize:12.0];
            teacherReplyLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:teacherReplyLabel];
        }
        
        if (self.isEvaluationStream) {
            NSInteger numberOfStars;
            numberOfStars = [[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_EVALUATION_INFO_EFFECT] integerValue];
            if (!numberOfStars) {
                UILabel *noStarLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 68, 150, 19)];
                noStarLabel.text = @"这节课没有评分信息 :(";
                noStarLabel.textColor = [UIColor lightGrayColor];
                noStarLabel.textAlignment = NSTextAlignmentLeft;
                noStarLabel.font = [UIFont boldSystemFontOfSize:13.0];
                [contentBg addSubview:noStarLabel];
            } else {
                UILabel *starDiscriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 68, 60, 19)];
                starDiscriptionLabel.backgroundColor = [UIColor clearColor];
                starDiscriptionLabel.text = @"学习效果:";
                starDiscriptionLabel.textColor = [UIColor lightGrayColor];
                starDiscriptionLabel.textAlignment = NSTextAlignmentLeft;
                starDiscriptionLabel.font = [UIFont boldSystemFontOfSize:13.0];
                [contentBg addSubview:starDiscriptionLabel];
                
                UIImage *starImage = [UIImage imageNamed:[NSString stringWithFormat:@"stream_star_%d", numberOfStars]];
                UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(82, 68, 100, 19)];
                starImageView.image = starImage;
                [contentBg addSubview:starImageView];
            }
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == [self.mutableStreams count]) {
        UITableViewCell *loadMoreCell = [tableView cellForRowAtIndexPath:indexPath];
        loadMoreCell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == [self.mutableStreams count]) {
        UITableViewCell *loadMoreCell = [tableView cellForRowAtIndexPath:indexPath];
        loadMoreCell.contentView.backgroundColor = [UIColor clearColor];
        for (UILabel *loadMoreLabel in loadMoreCell.contentView.subviews) {
            loadMoreLabel.text = @"正在加载...";
        }
        [self performSelectorInBackground:@selector(fetchMoreStreams:) withObject:loadMoreCell];
    } else {
        [self performSegueWithIdentifier:@"Stream Detail" sender:indexPath];
    }
}

- (void)appendTableWith:(NSArray *)streams
{
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
    for (int n = 0; n < [streams count]; n++) {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.mutableStreams indexOfObject:[streams objectAtIndex:n]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)fetchMoreStreams:(UITableViewCell *)sender
{
    NSDictionary *latestStreams;
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
        if (self.isEvaluationStream) {
            latestStreams = [StreamFetcher fetchTeacherLatestEvaluationStreamsByUsingNumberOfLastUpdatedStream:self.edidOfLastUpdatedStream andCtid:self.ctid];
        } else {
            latestStreams = [StreamFetcher fetchTeacherLatestStreamsByUsingNumberOfLastUpdatedStream:self.edidOfLastUpdatedStream andCtid:self.ctid];
        }
    } else {
        if (self.isEvaluationStream) {
            latestStreams = [StreamFetcher fetchLatestEvaluationStreamsByUsingNumberOfLastUpdatedStream:self.edidOfLastUpdatedStream];
        } else {
            latestStreams = [StreamFetcher fetchLatestStreamsByUsingNumberOfLastUpdatedStream:self.edidOfLastUpdatedStream];
        }
    }
    
    self.streamsDic = latestStreams;
    self.latestStreams = [latestStreams objectForKey:@"streamInfo"];
    self.edidOfLastUpdatedStream = [latestStreams objectForKey:@"edidOfLastUpdatedStream"];
    
    if ([self.latestStreams count]) {
        [self.mutableStreams addObjectsFromArray:self.latestStreams];
        [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:self.latestStreams waitUntilDone:NO];
    } else {
        for (UILabel *loadMoreLabel in sender.contentView.subviews) {
            loadMoreLabel.text = @"已经是最后一条了 :-)";
        }
    }
}

- (void)fetchInitialStudentEvaluationStream
{
    [self.refreshControl beginRefreshing];
    if (self.tableView.contentOffset.y == 0) {
        [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    }
    dispatch_queue_t fetchQ = dispatch_queue_create("Stream Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSDictionary *streams;
        if (self.isEvaluationStream) {
            streams = [StreamFetcher fetchInitialEvaluationStreams];
        } else {
            streams = [StreamFetcher fetchInitialStreams];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.streamsDic = streams;
            self.streams = [streams objectForKey:@"streamInfo"];
            self.mutableStreams = [self.streams mutableCopy];
            self.edidOfLastUpdatedStream = [streams objectForKey:@"edidOfLastUpdatedStream"];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
            if (![self.streams count]) {
                [self.noStreamImageView removeFromSuperview];
                [self.noStreamArrowImageView removeFromSuperview];
                self.noStreamImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_stream"]];
                self.noStreamImageView.contentMode = UIViewContentModeTop;
                self.noStreamImageView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height - 64);
                [self.view addSubview:self.noStreamImageView];
                self.noStreamArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_stream_arrow"]];
                self.noStreamArrowImageView.frame = CGRectMake(228, 10, 59, 54);
                [self.view addSubview:self.noStreamArrowImageView];
            } else {
                [self.noStreamImageView removeFromSuperview];
                [self.noStreamArrowImageView removeFromSuperview];
            }
        });
    });
}

- (void)fetchTeacherEvaluationStream
{
    [self.refreshControl beginRefreshing];
    if (self.tableView.contentOffset.y == 0) {
        [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    }
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Teacher Stream Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSDictionary *streams;
        if (self.isEvaluationStream) {
            streams = [StreamFetcher fetchTeacherEvaluationStreamsByCtid:self.ctid];
        } else {
            streams = [StreamFetcher fetchTeacherStreamsByCtid:self.ctid];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.streamsDic = streams;
            self.streams = [streams objectForKey:@"streamInfo"];
            self.mutableStreams = [self.streams mutableCopy];
            self.edidOfLastUpdatedStream = [streams objectForKey:@"edidOfLastUpdatedStream"];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
            if (![self.streams count]) {
                [self.noStreamLabel removeFromSuperview];
                self.noStreamLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, self.tableView.frame.size.height - 84)];
                self.noStreamLabel.text = @"没有任何内容\n快让您的学生参与随堂反馈吧！";
                self.noStreamLabel.font = [UIFont systemFontOfSize:19];
                self.noStreamLabel.numberOfLines = 2;
                self.noStreamLabel.backgroundColor = [UIColor clearColor];
                self.noStreamLabel.textColor = [UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1];
                self.noStreamLabel.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:self.noStreamLabel];
            } else {
                [self.noStreamLabel removeFromSuperview];
            }
        });
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat rotateAngle;
    if (self.view.frame.size.height <= 480) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            rotateAngle = scrollView.contentOffset.y / 44;
        } else {
            rotateAngle = (scrollView.contentOffset.y + 64) / 64;
        }
    } else {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            rotateAngle = scrollView.contentOffset.y / 44;
        } else {
            rotateAngle = (scrollView.contentOffset.y + 64) / 64;
        }
    }
    if (rotateAngle < -0.6) {
        rotateAngle = -0.6;
    }
    self.noStreamArrowImageView.transform = CGAffineTransformMakeRotation(rotateAngle);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Stream Detail"]) {
        if ([segue.destinationViewController isKindOfClass:[StreamDetailViewController class]]) {
            StreamDetailViewController *streamDetailVC;
            streamDetailVC = segue.destinationViewController;
            NSIndexPath *indexPath = sender;
            
            NSDictionary *stream = [self.mutableStreams objectAtIndex:indexPath.item];
            if (self.isEvaluationStream) {
                streamDetailVC.edid = [[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_EVALUATION_INFO_CAID] description];
                streamDetailVC.numberOfEffect = [[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_EVALUATION_INFO_EFFECT] integerValue];
                if ([[[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] isEqualToString:@""] || [[[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] isEqualToString:@"null"] || [[[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] isEqualToString:@"(null)"]) {
                    streamDetailVC.content = @"无意见建议";
                } else {
                    streamDetailVC.content = [[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description];
                }
                streamDetailVC.date = [[[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_SUMMARY_INFO_TIME] description];
                streamDetailVC.schoolnumber = [[stream objectForKey:STREAM_EVALUATION_INFO] objectForKey:STREAM_INFO_SCHOOLNUMBER];
            } else {
                if ([[[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] isEqualToString:@""] || [[[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] isEqualToString:@"null"] || [[[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] isEqualToString:@"(null)"]) {
                    streamDetailVC.content = @"无意见建议";
                } else {
                    streamDetailVC.content = [[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_CONTENT] description];
                }
                streamDetailVC.edid = [[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_INFO_EDID] description];
                streamDetailVC.date = [[[stream objectForKey:STREAM_INFO] objectForKey:STREAM_SUMMARY_INFO_TIME] description];
                streamDetailVC.numberOfLikes = [[stream objectForKey:STREAM_LIKE_NUMBER] integerValue];
                streamDetailVC.schoolnumber = [[stream objectForKey:STREAM_INFO] objectForKey:STREAM_INFO_SCHOOLNUMBER];
            }
            
            streamDetailVC.courseName = [[stream objectForKey:STREAM_COURSE_NAME] description];
            streamDetailVC.numberOfComments = [[[stream objectForKey:STREAM_COMMENT] objectForKey:STREAM_COMMENT_LIST] count];
            streamDetailVC.isLiked = [[stream objectForKey:STREAM_EVER_LIKE] isEqualToString:@"true"];
            streamDetailVC.isEvaluationStream = self.isEvaluationStream;
        }
    }
}

- (void)titleSwitchButtonPressed:(UIButton *)sender
{
    if ([self.navigationItem.title isEqualToString:@"感受"]) {
        self.navigationItem.title = @"小结";
        self.isEvaluationStream = YES;
        sender.selected = !sender.isSelected;
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.switchArrowImage.transform = CGAffineTransformRotate(self.switchArrowImage.transform, M_PI);
            } completion:nil];
        } else {
            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.switchArrowImage.transform = CGAffineTransformRotate(self.switchArrowImage.transform, M_PI);
            } completion:nil];
        }
    } else {
        self.navigationItem.title = @"感受";
        self.isEvaluationStream = NO;
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.switchArrowImage.transform = CGAffineTransformRotate(self.switchArrowImage.transform, M_PI);
            } completion:nil];
        } else {
            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.switchArrowImage.transform = CGAffineTransformRotate(self.switchArrowImage.transform, M_PI);
            } completion:nil];
        }
    }
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
        [self fetchTeacherEvaluationStream];
    } else {
        [self fetchInitialStudentEvaluationStream];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.titleSwitchButton removeFromSuperview];
    [self.switchArrowImage removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.switchArrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stream_down_arrow"]];
    self.switchArrowImage.frame = CGRectMake(185, 14, 18, 18);
    if ([self.navigationItem.title isEqualToString:@"感受"]) {
        self.switchArrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    }
    [self.navigationController.navigationBar addSubview:self.switchArrowImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.titleSwitchButton.frame = CGRectMake(96, 6, 128, 33);
    self.titleSwitchButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar_transparent"]];
    [self.titleSwitchButton addTarget:self action:@selector(titleSwitchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.titleSwitchButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isEvaluationStream = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:213.0/255.0 blue:217.0/255.0 alpha:1];
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
        [self.refreshControl addTarget:self action:@selector(fetchTeacherEvaluationStream) forControlEvents:UIControlEventValueChanged];
        [self fetchTeacherEvaluationStream];
    } else {
        [self.refreshControl addTarget:self action:@selector(fetchInitialStudentEvaluationStream) forControlEvents:UIControlEventValueChanged];
        [self fetchInitialStudentEvaluationStream];
    }
}

@end
