//
//  InitialSlidingViewController.m
//  Syllabus
//
//  Created by Jason J on 13-3-31.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "InitialSlidingViewController.h"

@implementation InitialSlidingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Stream"];
}

@end
