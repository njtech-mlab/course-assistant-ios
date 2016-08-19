//
//  EvaluationTextView.m
//  南工评教
//
//  Created by Jason J on 13-5-2.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "EvaluationTextView.h"

@interface EvaluationTextView()
@property (retain, nonatomic) UILabel *placeHolderLabel;
@end

@implementation EvaluationTextView

- (void)drawRect:(CGRect)rect
{
    if([[self placeholder] length] > 0) {
        if (_placeHolderLabel == nil) {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    if([[self text] length] == 0 && [[self placeholder] length] > 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0) return;
    if([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1];
    } else {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 10);
}

#define TEXT_FIELD_BORDER_RADIUS 6.0f
#define TEXT_FIELD_ALPHA 0.9

- (void)setup
{
    // Do initialization here
    self.layer.cornerRadius = TEXT_FIELD_BORDER_RADIUS;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    self.alpha = TEXT_FIELD_ALPHA;

    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    return self;
}

@end
