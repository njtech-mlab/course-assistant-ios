//
//  InitialViewController.m
//  南工云课堂
//
//  Created by Jason J on 13-4-22.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "InitialViewController.h"
#import "UIManagedDocumentHandler.h"

@interface InitialViewController()
@property (weak, nonatomic) id <UIManagedDocumentHandlerDelegate> managedDocumentHandlerDelegate;
@end

@implementation InitialViewController

@synthesize managedDocumentHandlerDelegate = _managedDocumentHandlerDelegate;

- (id <UIManagedDocumentHandlerDelegate>)managedDocumentHandlerDelegate
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if(!_managedDocumentHandlerDelegate && [appDelegate conformsToProtocol: @protocol(UIManagedDocumentHandlerDelegate)]) {
        return appDelegate;
    }
    return _managedDocumentHandlerDelegate;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    NSURL *rootUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask] lastObject];
    NSURL *studentUrl = [rootUrl URLByAppendingPathComponent:@"Student Document"];
    BOOL studentFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[studentUrl path]];
    if (studentFileExists) {
        [self.managedDocumentHandlerDelegate openCalendarDocument:^(BOOL finished) {
            if (finished) {
                [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"Initial Sliding"]
                                   animated:NO
                                 completion:nil];
            } else {
                NSLog(@"student file open failed");
                NSError *error;
                BOOL successRemovingTeacherFile = [[NSFileManager defaultManager] removeItemAtPath:[studentUrl path] error:&error];
                if (!successRemovingTeacherFile) {
                    NSLog(@"student file delete failed");
                }
                [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"Welcome"]
                                   animated:NO
                                 completion:nil];
            }
        }];
    } else {
        NSURL *teacherUrl = [rootUrl URLByAppendingPathComponent:@"Teacher Document"];
        BOOL teacherFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[teacherUrl path]];
        if (teacherFileExists) {
            [self.managedDocumentHandlerDelegate openCalendarDocument:^(BOOL finished) {
                if (finished) {
                    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"Teacher"]
                                       animated:NO
                                     completion:nil];
                } else {
                    NSLog(@"teacher file open failed");
                    NSError *error;
                    BOOL successRemovingTeacherFile = [[NSFileManager defaultManager] removeItemAtPath:[teacherUrl path] error:&error];
                    if (!successRemovingTeacherFile) {
                        NSLog(@"teacher file delete failed");
                    }
                    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"Welcome"]
                                       animated:NO
                                     completion:nil];
                }
            }];
        } else {
            NSLog(@"no student or teacher file found");
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"Welcome"]
                               animated:NO
                             completion:nil];
        }
    }
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
