//
//  EvaluationTextView.h
//  南工评教
//
//  Created by Jason J on 13-5-2.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationTextView : UITextView

@property (retain, nonatomic) NSString *placeholder;
@property (retain, nonatomic) UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;

@end
