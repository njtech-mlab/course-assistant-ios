//
//  StreamCommentTVC.m
//  课程助理
//
//  Created by Jason J on 2/8/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "StreamCommentTVC.h"
#import "StreamFetcher.h"

@interface StreamCommentTVC ()
@property (strong, nonatomic) NSDictionary *streamsDic;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSMutableArray *mutableComments;
@property (strong, nonatomic) UIImageView *background;
@property (nonatomic) BOOL isLoaded;
@end

@implementation StreamCommentTVC

- (void)fetchComments
{
    self.isLoaded = NO;
    dispatch_queue_t fetchQ = dispatch_queue_create("Stream Comment Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSDictionary *streams;
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
            if (self.isEvaluationStream) {
                streams = [StreamFetcher fetchTeacherStreamEvaluationDetailByEdid:self.edid];
            } else {
                streams = [StreamFetcher fetchTeacherStreamDetailByEdid:self.edid];
            }
        } else {
            if (self.isEvaluationStream) {
                streams = [StreamFetcher fetchStreamEvaluationDetailByEdid:self.edid];
            } else {
                streams = [StreamFetcher fetchStreamDetailByEdid:self.edid];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.streamsDic = streams;
            self.comments = [[[streams objectForKey:@"streamInfo"] objectForKey:STREAM_COMMENT] objectForKey:STREAM_COMMENT_LIST];
            self.mutableComments = [self.comments mutableCopy];
            self.isLoaded = YES;
            [self.tableView reloadData];
            
            CGFloat tableViewHeight = self.tableView.contentSize.height;
            self.background.frame = CGRectMake(5, 10, 310, tableViewHeight - 5);
            self.background.image = [[UIImage imageNamed:@"stream_comment_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            
            [self.tableView sendSubviewToBack:self.background];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchComments];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.background removeFromSuperview];
    CGFloat tableViewHeight = 0;
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        tableViewHeight = tableViewHeight + cell.frame.size.height;
    }
    self.background = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 310, tableViewHeight - 5)];
    self.background.image = [[UIImage imageNamed:@"stream_comment_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.tableView addSubview:self.background];
    [self.tableView sendSubviewToBack:self.background];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;
    if ([self.mutableComments count] == 0) {
        rows = 3;
    } else {
        rows = 2 + [self.mutableComments count];
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.item == 0) {
        if (self.isEvaluationStream) {
            height = [self.content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(225, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + 150.0;
        } else {
            height = [self.content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(225, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + 130.0;
        }
    } else if (indexPath.item == 1) {
        height = 40;
    } else {
        if ([self.mutableComments count] == 0) {
            height = 44;
        } else {
            NSDictionary *comment = [self.mutableComments objectAtIndex:indexPath.item - 2];
            height = [[[comment objectForKey:STREAM_SUMMARY_INFO_CONTENT] description] sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(225, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + 50.0;
        }
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StreamCommentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.item == 0) {
        if (!self.isEvaluationStream) {
            UILabel *likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 50, 50)];
            likeNumberLabel.backgroundColor = [UIColor whiteColor];
            likeNumberLabel.layer.borderWidth = 1.0f;
            if (self.numberOfLikes == 0) {
                likeNumberLabel.textColor = [UIColor lightGrayColor];
                likeNumberLabel.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
            } else if (self.numberOfLikes > 0) {
                likeNumberLabel.layer.borderColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1].CGColor;
                likeNumberLabel.textColor = [UIColor colorWithHue:145.0/360.0 saturation:0.78 brightness:0.78 alpha:1];
            } else if (self.numberOfLikes < 0) {
                likeNumberLabel.layer.borderColor = [UIColor colorWithHue:349.0/360.0 saturation:0.77 brightness:0.86 alpha:1].CGColor;
                likeNumberLabel.textColor = [UIColor colorWithHue:349.0/360.0 saturation:0.77 brightness:0.86 alpha:1];
            }
            if (!self.numberOfLikes) {
                likeNumberLabel.text = @"0";
            } else {
                likeNumberLabel.text = [NSString stringWithFormat:@"+%d", self.numberOfLikes];
            }
            likeNumberLabel.textAlignment = NSTextAlignmentCenter;
            likeNumberLabel.font = [UIFont systemFontOfSize:23.0];
            likeNumberLabel.layer.cornerRadius = 25.0;
            [cell.contentView addSubview:likeNumberLabel];
        }
        
        UILabel *contentLabel;
        if (self.isEvaluationStream) {
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 270, 2008)];
        } else {
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 270, 2008)];
        }
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.text = self.content;
        contentLabel.textColor = [UIColor darkTextColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
        [cell.contentView addSubview:contentLabel];
        
        UILabel *courseNameLabel;
        if (self.isEvaluationStream) {
            courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 260, 21)];
        } else {
            courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 30, 210, 21)];
        }
        courseNameLabel.backgroundColor = [UIColor clearColor];
        courseNameLabel.text = self.courseName;
        courseNameLabel.textColor = [UIColor darkTextColor];
        courseNameLabel.textAlignment = NSTextAlignmentLeft;
        courseNameLabel.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:courseNameLabel];
        
        UILabel *dateLabel;
        if (self.isEvaluationStream) {
            dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 56, 260, 21)];
        } else {
            dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 56, 210, 21)];
        }
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.text = self.date;
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.font = [UIFont systemFontOfSize:13.0];
        [cell.contentView addSubview:dateLabel];
        
        if (self.isEvaluationStream) {
            NSInteger numberOfstars = self.numberOfEffect;
            if (!numberOfstars) {
                UILabel *noStarLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 82, 150, 19)];
                noStarLabel.text = @"这节课没有评分信息 :(";
                noStarLabel.textColor = [UIColor lightGrayColor];
                noStarLabel.textAlignment = NSTextAlignmentLeft;
                noStarLabel.font = [UIFont boldSystemFontOfSize:13.0];
                [cell.contentView addSubview:noStarLabel];
            } else {
                UILabel *starDiscriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 82, 60, 19)];
                starDiscriptionLabel.backgroundColor = [UIColor clearColor];
                starDiscriptionLabel.text = @"学习效果:";
                starDiscriptionLabel.textColor = [UIColor lightGrayColor];
                starDiscriptionLabel.textAlignment = NSTextAlignmentLeft;
                starDiscriptionLabel.font = [UIFont boldSystemFontOfSize:13.0];
                [cell.contentView addSubview:starDiscriptionLabel];
                
                UIImage *starImage = [UIImage imageNamed:[NSString stringWithFormat:@"stream_star_%d", numberOfstars]];
                UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(92, 82, 100, 19)];
                starImageView.image = starImage;
                [cell.contentView addSubview:starImageView];
            }
        }
        
        UILabel *statisticLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, cell.frame.size.height - 30, 150, 21)];
        statisticLabel.font = [UIFont boldSystemFontOfSize:12.0];
        statisticLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:156.0/255.0 blue:161.0/255.0 alpha:1];
        statisticLabel.text = [NSString stringWithFormat:@"%d 条评论", self.numberOfComments];
        [cell.contentView addSubview:statisticLabel];
    } else if (indexPath.item == 1) {
        UIImageView *buttonsBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
        buttonsBg.image = [[UIImage imageNamed:@"stream_comment_button_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        buttonsBg.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:buttonsBg];
        
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] > 5) {
            if (!self.isEvaluationStream) {
                UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 105, 21)];
                UIButton *up = [UIButton buttonWithType:UIButtonTypeCustom];
                upLabel.backgroundColor = [UIColor clearColor];
                upLabel.textAlignment = NSTextAlignmentCenter;
                upLabel.font = [UIFont boldSystemFontOfSize:12.0];
                if (self.isLiked) {
                    upLabel.text = @"-1";
                } else {
                    upLabel.text = @"+1";
                }
                upLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:156.0/255.0 blue:161.0/255.0 alpha:1];
                [cell.contentView addSubview:upLabel];
                UIImage *upImage = [UIImage imageNamed:@"thumb"];
                [up setBackgroundImage:upImage forState:UIControlStateNormal];
                up.frame = CGRectMake(20, 2, 150, 35);
                [cell.contentView addSubview:up];
                [cell.contentView bringSubviewToFront:upLabel];
            }
        }
        
        UILabel *commentLabel;
        if (self.isEvaluationStream || [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
            commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 10, 95, 21)];
        } else {
            commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(202, 10, 95, 21)];
        }
        UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.textAlignment = NSTextAlignmentCenter;
        commentLabel.font = [UIFont boldSystemFontOfSize:12.0];
        commentLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:156.0/255.0 blue:161.0/255.0 alpha:1];
        commentLabel.text = @"评论";
        [cell.contentView addSubview:commentLabel];
        UIImage *commentImage = [UIImage imageNamed:@"comment"];
        [comment setBackgroundImage:commentImage forState:UIControlStateNormal];
        if (self.isEvaluationStream || [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
            comment.frame = CGRectMake(65, 2, 150, 35);
        } else {
            comment.frame = CGRectMake(145, 2, 150, 35);
        }
        [comment addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:comment];
        [cell.contentView bringSubviewToFront:commentLabel];
    }
    if (![self.mutableComments count]) {
        if (indexPath.item == 2) {
            UILabel *noCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 290, 21)];
            if (self.isLoaded) {
                noCommentLabel.text = @"还没有评论，快来抢沙发~";
            } else {
                noCommentLabel.text = @"努力加载中...";
            }
            noCommentLabel.font = [UIFont systemFontOfSize:14.0];
            noCommentLabel.backgroundColor = [UIColor clearColor];
            noCommentLabel.textAlignment = NSTextAlignmentCenter;
            noCommentLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:156.0/255.0 blue:161.0/255.0 alpha:1];
            [cell.contentView addSubview:noCommentLabel];
        }
    } else {
        if (indexPath.item >= 2) {
            NSDictionary *comment = [self.mutableComments objectAtIndex:indexPath.item - 2];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 80, 21)];
            nameLabel.backgroundColor = [UIColor clearColor];
            if ([[comment objectForKey:STREAM_SUMMARY_INFO_CONTENT] length] > 3) {
                if ([[[comment objectForKey:STREAM_SUMMARY_INFO_CONTENT] substringToIndex:3] isEqualToString:@"[T]"]) {
                    nameLabel.text = @"教师用户";
                } else {
                    nameLabel.text = @"匿名用户";
                }
            } else {
                nameLabel.text = @"匿名用户";
            }
            nameLabel.textColor = [UIColor darkTextColor];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont systemFontOfSize:15.0];
            [cell.contentView addSubview:nameLabel];
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 10, 170, 21)];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.text = [comment objectForKey:STREAM_SUMMARY_INFO_TIME];
            dateLabel.textColor = [UIColor lightGrayColor];
            dateLabel.textAlignment = NSTextAlignmentRight;
            dateLabel.font = [UIFont systemFontOfSize:13.0];
            [cell.contentView addSubview:dateLabel];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 40, 260, 2008)];
            contentLabel.backgroundColor = [UIColor clearColor];
            if ([[comment objectForKey:STREAM_SUMMARY_INFO_CONTENT] length] > 3) {
                if ([[[comment objectForKey:STREAM_SUMMARY_INFO_CONTENT] substringToIndex:3] isEqualToString:@"[T]"] || [[[comment objectForKey:STREAM_SUMMARY_INFO_CONTENT] substringToIndex:3] isEqualToString:@"[S]"]) {
                    contentLabel.text = [[comment objectForKey:STREAM_SUMMARY_INFO_CONTENT] substringFromIndex:3];
                } else {
                    contentLabel.text = [comment objectForKey:STREAM_SUMMARY_INFO_CONTENT];
                }
            } else {
                contentLabel.text = [comment objectForKey:STREAM_SUMMARY_INFO_CONTENT];
            }
            contentLabel.textColor = [UIColor darkGrayColor];
            contentLabel.textAlignment = NSTextAlignmentLeft;
            contentLabel.font = [UIFont systemFontOfSize:15.0];
            contentLabel.numberOfLines = 0;
            [contentLabel sizeToFit];
            [cell.contentView addSubview:contentLabel];
            
            if (indexPath.item != 1 + [self.mutableComments count]) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.frame.size.height - 1, 290, 1)];
                line.backgroundColor = [UIColor  colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
                [cell.contentView addSubview:line];
            }
        }
    }
    return cell;
}

- (void)appendNewCommentWithContent:(NSString *)content fromUser:(NSString *)from toUser:(NSString *)to edid:(NSString *)edid
{
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
        content = [NSString stringWithFormat:@"[T]%@", content];
    } else {
        content = [NSString stringWithFormat:@"[S]%@", content];
    }
    NSDictionary *newComment = @{ @"commentid" : @"", @"content" : content, @"fromuser" : from, @"infoid" : edid, @"timestamp" : @"", @"touser" : to };
    [self.mutableComments addObject:newComment];
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.mutableComments count] inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.tableView beginUpdates];
    if ([self.mutableComments count] == 1) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView reloadData];
    
    [self.tableView sendSubviewToBack:self.background];
    
    CGFloat tableViewHeight = self.tableView.contentSize.height;
    self.background.frame = CGRectMake(5, 10, 310, tableViewHeight - 5);
    self.background.image = [[UIImage imageNamed:@"stream_comment_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

- (void)commentPressed:(UIButton *)sender
{
    [self.delegate bringKeyboard];
}

@end
