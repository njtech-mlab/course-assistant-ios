//
//  MessageTableViewCell.h
//  南工课立方
//
//  Created by Jason J on 13-5-20.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageCellContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageIconView;

@end
