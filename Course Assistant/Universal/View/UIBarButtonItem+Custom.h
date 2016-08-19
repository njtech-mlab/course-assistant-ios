//
//  UIBarButtonItem+Custom.h
//  南工云课堂
//
//  Created by Jason J on 13-4-23.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image
                               target:(id)target
                               action:(SEL)action
                           edgeInsets:(UIEdgeInsets)insets
                                width:(CGFloat)width
                               height:(CGFloat)height;

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image
                               target:(id)target
                               action:(SEL)action
                           edgeInsets:(UIEdgeInsets)insets
                                width:(CGFloat)width
                               height:(CGFloat)height
                     highlightedImage:(UIImage *)highlightedImage;

@end
