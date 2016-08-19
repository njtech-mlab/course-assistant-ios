//
//  LoginTextField.m
//  南工云课堂
//
//  Created by Jason J on 13-4-21.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginTextField.h"

@implementation LoginTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 10);
}

#define TEXT_FIELD_BORDER_RADIUS 15.0f
#define TEXT_FIELD_ALPHA 0.85

- (void)setup
{
    // Do initialization here
    self.layer.cornerRadius = TEXT_FIELD_BORDER_RADIUS;
    self.alpha = TEXT_FIELD_ALPHA;
    self.borderStyle = UITextBorderStyleNone;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
