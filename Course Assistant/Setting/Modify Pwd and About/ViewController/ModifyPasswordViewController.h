//
//  ModifyPasswordViewController.h
//  课程助理
//
//  Created by Jason J on 13-5-27.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModifyPasswordViewController;

@protocol ModifyPasswordViewControllerDelegate <NSObject>
- (void)haveModifiedPassword;
- (void)willDismissModifyPasswordViewController;
@end

@interface ModifyPasswordViewController : UIViewController

@property (weak, nonatomic) id <ModifyPasswordViewControllerDelegate> delegate;

@end
