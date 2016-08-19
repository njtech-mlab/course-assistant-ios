//
//  UIBarButtonItem+Custom.m
//  南工云课堂
//
//  Created by Jason J on 13-4-23.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image
                               target:(id)target
                               action:(SEL)action
                           edgeInsets:(UIEdgeInsets)insets
                                width:(CGFloat)width
                               height:(CGFloat)height
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[image resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, width, height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [view addSubview:button];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    return barButtonItem;
}

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image
                               target:(id)target
                               action:(SEL)action
                           edgeInsets:(UIEdgeInsets)insets
                                width:(CGFloat)width
                               height:(CGFloat)height
                     highlightedImage:(UIImage *)highlightedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[image resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [button setBackgroundImage:[highlightedImage resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, width, height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [view addSubview:button];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    return barButtonItem;
}

@end
