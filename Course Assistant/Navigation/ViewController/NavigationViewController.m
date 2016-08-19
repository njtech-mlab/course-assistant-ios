//
//  NavigationViewController.m
//  Syllabus
//
//  Created by Jason J on 13-3-31.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NavigationViewController.h"
#import "ECSlidingViewController.h"
#import "MenuTVC.h"
#import "MessageTVC.h"

@interface NavigationViewController () <MenuTVCDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *messageContainer;
//@property (weak, nonatomic) UIActionSheet *avatarActionSheet;
@property (strong, nonatomic) UIImageView *avatarImageView;
@end

@implementation NavigationViewController

- (void)menuTVC:(MenuTVC *)sender didSelectMessageCell:(BOOL)selected
{
    if (selected) {
        self.messageContainer.hidden = NO;
    } else {
        self.messageContainer.hidden = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Menu"]) {
        if ([segue.destinationViewController isKindOfClass:[MenuTVC class]]) {
            MenuTVC *menu = (MenuTVC *)segue.destinationViewController;
            menu.delegate = self;
        }
    }
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.firstNameLabel removeFromSuperview];
        self.firstNameLabel = nil;
        
        CGRect rect = CGRectMake(0, 0, 150, 150);
        UIGraphicsBeginImageContext(rect.size);
        [[info objectForKey:UIImagePickerControllerEditedImage] drawInRect:rect];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.avatarImageView.image = scaledImage;
        NSData *avatarData = UIImagePNGRepresentation(scaledImage);
        [avatarData writeToFile:[self avatarPath] atomically:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
*/
 
#define ACTION_SHEET_TITLE @"设置头像"
#define ACTION_SHEET_CHOOSING @"从相册选择"
#define ACTION_SHEET_TAKING @"使用手机拍照"
#define ACTION_SHEET_CANCEL @"取消"

/*
- (void)tapOnAvatar:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (!self.avatarActionSheet) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:ACTION_SHEET_TITLE
                                                                     delegate:self
                                                            cancelButtonTitle:ACTION_SHEET_CANCEL
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:ACTION_SHEET_CHOOSING, ACTION_SHEET_TAKING, nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view];
            self.avatarActionSheet = actionSheet;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
*/

- (NSString *)avatarPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:@"avatar.png"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    if (!self.avatarImageView) {
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
        [self.avatarImageView.layer setCornerRadius:15.0];
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.backgroundColor = [UIColor colorWithWhite:0.57 alpha:1];
        self.avatarImageView.userInteractionEnabled = YES;
        [self.view addSubview:self.avatarImageView];
    }
    
    if (![NSData dataWithContentsOfFile:[self avatarPath]]) {
        if (!self.firstNameLabel) {
            self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
            self.firstNameLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"studentName"] substringToIndex:1];
            self.firstNameLabel.font = [UIFont systemFontOfSize:64.0];
            self.firstNameLabel.textAlignment = NSTextAlignmentCenter;
            self.firstNameLabel.textColor = [UIColor whiteColor];
            self.firstNameLabel.backgroundColor = [UIColor clearColor];
            [self.avatarImageView addSubview:self.firstNameLabel];
        }
    } else {
        self.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self avatarPath]]];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnAvatar:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.avatarImageView addGestureRecognizer:tapGesture];
    */
    
    /*
    if (!self.avatarImageView) {
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 51, 28, 29)];
        [self.avatarImageView.layer setCornerRadius:5.0];
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.backgroundColor = [UIColor colorWithWhite:0.57 alpha:1];
        self.avatarImageView.userInteractionEnabled = YES;
        [self.view addSubview:self.avatarImageView];
    }
    */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set navigation reveal amount
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [self.slidingViewController setAnchorRightRevealAmount:230.0f];
    } else {
        [self.slidingViewController setAnchorRightRevealAmount:220.0f];
    }
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    // Set navigation background
    //UIImage *img = [UIImage imageNamed:@"menu_background.png"];
    //UIColor *bg = [[UIColor alloc] initWithPatternImage:img];
    //self.view.backgroundColor = bg;
    
    self.messageContainer.hidden = YES;
}

@end
