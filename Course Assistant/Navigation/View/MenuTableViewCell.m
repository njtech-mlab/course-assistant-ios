//
//  MenuTableViewCell.m
//  南工评教
//
//  Created by Jason J on 13-4-26.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "MenuTableViewCell.h"

@interface MenuTableViewCell ()

@end

@implementation MenuTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        for (UIImageView *image in self.contentView.subviews) {
            if (image.frame.size.width > 200.0) {
                image.alpha = 0.15;
            }
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        for (UIImageView *image in self.contentView.subviews) {
            if (image.frame.size.width > 200.0) {
                image.alpha = 0.15;
            }
        }
    }
}

@end
