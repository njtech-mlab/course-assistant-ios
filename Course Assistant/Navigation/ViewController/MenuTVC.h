//
//  MenuTVC.h
//  Syllabus
//
//  Created by Jason J on 13-3-31.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuTVC;

@protocol MenuTVCDelegate <NSObject>
@optional
- (void)menuTVC:(MenuTVC *)sender didSelectMessageCell:(BOOL)selected;
@end

@interface MenuTVC : UITableViewController

@property (weak, nonatomic) id <MenuTVCDelegate> delegate;

@end
