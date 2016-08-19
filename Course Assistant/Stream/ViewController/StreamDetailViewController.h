//
//  StreamDetailViewController.h
//  课程助理
//
//  Created by Jason J on 2/8/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamDetailViewController : UIViewController

@property (strong, nonatomic) NSString *edid;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *schoolnumber;
@property (nonatomic) NSInteger numberOfLikes;
@property (nonatomic) NSInteger numberOfComments;
@property (nonatomic) NSInteger numberOfEffect;
@property (nonatomic) BOOL isLiked;
@property (nonatomic) BOOL isEvaluationStream;

- (void)bringKeyboard;

@end
