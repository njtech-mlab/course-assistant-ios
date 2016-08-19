//
//  StreamDetailViewController.m
//  课程助理
//
//  Created by Jason J on 2/8/14.
//  Copyright (c) 2014 Ji WenTian. All rights reserved.
//

#import "StreamDetailViewController.h"
#import "StreamCommentTVC.h"
#import "EvaluationTextView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface StreamDetailViewController () <UITextViewDelegate, ASIHTTPRequestDelegate, StreamCommentTVCDelegate>
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) EvaluationTextView *textInputBox;
@property (strong, nonatomic) UIView *textInputView;
@property (strong, nonatomic) StreamCommentTVC *streamCommentTVC;
@end

@implementation StreamDetailViewController

- (StreamCommentTVC *)streamCommentTVC
{
    if (!_streamCommentTVC) {
        _streamCommentTVC = [[StreamCommentTVC alloc] init];
    }
    return _streamCommentTVC;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's
    // coordinate system. The bottom of the text view's frame should align with the top
    // of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView animateWithDuration:animationDuration animations:^{
        self.textInputView.frame = CGRectMake(0, keyboardTop - 46, 320, 46);
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView animateWithDuration:animationDuration animations:^{
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                self.textInputView.frame = CGRectMake(0, self.view.frame.size.height - 46, 320, 46);
            } else {
                self.textInputView.frame = CGRectMake(0, self.view.frame.size.height - 92, 320, 46);
            }
        } else {
            self.textInputView.frame = CGRectMake(0, self.view.frame.size.height - 46, 320, 46);
        }
    }];
}

- (void)dismissKeyboard:(UIButton *)sender
{
    [self.textInputBox resignFirstResponder];
}

- (void)bringKeyboard
{
    [self.textInputBox becomeFirstResponder];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error.localizedDescription);
    [self showErrorAlertUsingString:@"提交失败，请检查网络。"];
}

- (void)sendRequestDidFinishLoading:(ASIHTTPRequest *)request
{
    NSData *requestData = [request responseData];
    if (requestData) {
        NSDictionary *result = nil;
        NSError *error = nil;
        result = [NSJSONSerialization JSONObjectWithData:requestData
                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                   error:&error];
        if ([[result objectForKey:@"msg"] isEqualToString:@"succeed"]) {
            //[self showErrorAlertUsingString:@"评论成功！"];
        }
    } else {
        [self showErrorAlertUsingString:@"提交失败，请检查网络。"];
    }
}

#define SUMMARY_URL @"http://app.njut.org.cn/timetable/comment.action"
#define EVALUATION_URL @"http://app.njut.org.cn/timetable/advicecomment.action"
#define TEACHER_SUMMARY_URL @"http://app.njut.org.cn/timetable/teacherreply.action"
#define TEACHER_EVALUATION_URL @"http://app.njut.org.cn/timetable/teacherreplyadvice.action"

- (void)startConnectingWithPostBySchoolNumber:(NSString *)schoolnumber edid:(NSString *)edid content:(NSString *)content tag:(NSString *)tag commentId:(NSString *)commentId userName:(NSString *)userName;
{
    ASIFormDataRequest *request;
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
        if (self.isEvaluationStream) {
            request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TEACHER_EVALUATION_URL]];
        } else {
            request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TEACHER_SUMMARY_URL]];
        }
    } else {
        if (self.isEvaluationStream) {
            request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:EVALUATION_URL]];
        } else {
            request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SUMMARY_URL]];
        }
    }
    [request setPostValue:userName forKey:@"from"];
    [request setPostValue:schoolnumber forKey:@"to"];
    [request setPostValue:edid forKey:@"edid"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:tag forKey:@"tag"];
    [request setPostValue:commentId forKey:@"commentid"];
    [request setRequestMethod:@"POST"];
    request.delegate = self;
    request.didFinishSelector = @selector(sendRequestDidFinishLoading:);
    request.timeOutSeconds = 20;
    [request startAsynchronous];
    
    [self.streamCommentTVC appendNewCommentWithContent:content fromUser:userName toUser:schoolnumber edid:edid];
}

- (void)sendComment:(UIButton *)sender
{
    if (self.textInputBox.text.length == 0) {
        [self dismissKeyboard:nil];
    } else {
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
            [self startConnectingWithPostBySchoolNumber:self.schoolnumber edid:self.edid content:self.textInputBox.text tag:@"1" commentId:nil userName:[[NSUserDefaults standardUserDefaults] valueForKey:@"teacherNumber"]];
        } else {
            [self startConnectingWithPostBySchoolNumber:self.schoolnumber edid:self.edid content:self.textInputBox.text tag:@"1" commentId:nil userName:[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
        }
        self.textInputBox.text = @"";
        [self dismissKeyboard:nil];
    }
}

- (void)showErrorAlertUsingString:(NSString *)errorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textInputBox resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Stream Comment"]) {
        if ([segue.destinationViewController isKindOfClass:[StreamCommentTVC class]]) {
            self.streamCommentTVC = segue.destinationViewController;
            self.streamCommentTVC.edid = self.edid;
            self.streamCommentTVC.content = self.content;
            self.streamCommentTVC.courseName = self.courseName;
            self.streamCommentTVC.date = self.date;
            self.streamCommentTVC.numberOfComments = self.numberOfComments;
            self.streamCommentTVC.numberOfLikes = self.numberOfLikes;
            self.streamCommentTVC.isLiked = self.isLiked;
            self.streamCommentTVC.numberOfEffect = self.numberOfEffect;
            self.streamCommentTVC.isEvaluationStream = self.isEvaluationStream;
            self.streamCommentTVC.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.textInputView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:213.0/255.0 blue:217.0/255.0 alpha:1];
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
            self.textInputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 138, 320, 46)];
        } else {
            self.textInputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 92, 320, 46)];
        }
    } else {
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] <= 5) {
            self.textInputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 94, 320, 46)];
        } else {
            self.textInputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 46, 320, 46)];
        }
    }
    [self.textInputView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"text_input_box_bg"]]];
    
    self.textInputBox = [[EvaluationTextView alloc] initWithFrame:CGRectMake(15, 6, 230, 34)];
    self.textInputBox.layer.cornerRadius = 6.0f;
    self.textInputBox.layer.borderWidth = 1.0;
    self.textInputBox.layer.borderColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0].CGColor;
    self.textInputBox.placeholder = @"写评论...（200字以内）";
    self.textInputBox.font = [UIFont systemFontOfSize:15.0];
    [self.textInputView addSubview:self.textInputBox];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithRed:0 green:123.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.sendButton.frame = CGRectMake(260, 6, 45, 34);
    [self.textInputView addSubview:self.sendButton];
    [self.sendButton addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textInputBox.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

@end
