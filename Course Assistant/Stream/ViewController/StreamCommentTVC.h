//
//  StreamCommentTVC.h
//  课程助理
//
//  Created by Jason J on 2/8/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StreamCommentTVC;

@protocol StreamCommentTVCDelegate <NSObject>
@optional
- (void)bringKeyboard;
@end

@interface StreamCommentTVC : UITableViewController

@property (strong, nonatomic) NSString *edid;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *date;
@property (nonatomic) NSInteger numberOfLikes;
@property (nonatomic) NSInteger numberOfComments;
@property (nonatomic) NSInteger numberOfEffect;
@property (nonatomic) BOOL isLiked;
@property (nonatomic) BOOL isEvaluationStream;

@property (weak, nonatomic) id <StreamCommentTVCDelegate> delegate;

- (void)appendNewCommentWithContent:(NSString *)content fromUser:(NSString *)from toUser:(NSString *)to edid:(NSString *)edid;

@end
