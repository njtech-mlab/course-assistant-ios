//
//  FeedbackViewController.m
//  南工课立方
//
//  Created by Jason J on 13-5-6.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//
/*
#import "FeedbackViewController-old.h"
#import "CalendarToolbar.h"
#import "UIBarButtonItem+Custom.h"
#import "EvaluationTextView.h"
#import "CommonFetch.h"

@interface FeedbackViewController-old () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *keyBoardAccessoryView;
@property (weak, nonatomic) IBOutlet UIImageView *textViewBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation FeedbackViewController-old

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
        self.keyBoardAccessoryView.frame = CGRectMake(0, keyboardTop - 46, 320, 46);
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
        self.keyBoardAccessoryView.frame = CGRectMake(0, self.view.frame.size.height - 46, 320, 46);
    }];
}

- (void)dismissKeyboard:(UIButton *)sender
{
    [self.textView resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#define PLACEHOLDER @"为了提高你的用户体验，欢迎反馈如下方面的信息：\r\n1) 使用过程中出现的问题。\r\n2) 期待的新功能。\r\n3) 欢迎吐槽任何细节问题。"
#define FONT_SIZE 13.0

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keyBoardAccessoryView.frame = CGRectMake(0, self.view.frame.size.height - 90, 320, 46);
    self.keyBoardAccessoryView.backgroundColor = [UIColor clearColor];
    
    self.textViewBackgroundImageView.image = [[UIImage imageNamed:@"messaging_input_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    
    self.textView.delegate = self;
    
    [self.sendButton setBackgroundImage:[[UIImage imageNamed:@"messaging_input_button_send_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[[UIImage imageNamed:@"messaging_input_button_pressed_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    [self.sendButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.keyBoardAccessoryView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

@end
*/