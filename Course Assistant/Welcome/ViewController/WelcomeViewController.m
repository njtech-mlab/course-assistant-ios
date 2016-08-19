//
//  WelcomeViewController.m
//  云知易课堂
//
//  Created by Jason J on 13-4-12.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "WelcomeScrollView.h"

@interface WelcomeViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet WelcomeScrollView *welcomScrollView;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) UIImageView *welcomeImageView1;
@property (strong, nonatomic) UIImageView *welcomeImageView2;
@property (strong, nonatomic) UIImageView *firstPic;
@property (strong, nonatomic) UIButton *firstButton;
@property (strong, nonatomic) UIButton *firstPopButton;
@property (strong, nonatomic) UIView *blackView;
@property (strong, nonatomic) UIView *popoverView;
@property (strong, nonatomic) UIPageControl *helpPageControl;
@property (nonatomic) BOOL popoverVisibility;
@end

@implementation WelcomeViewController

- (LoginViewController *)loginVC
{
    if (!_loginVC) {
        _loginVC = [[LoginViewController alloc] init];
    }
    return _loginVC;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Login"]) {
        if ([segue.destinationViewController isKindOfClass:[LoginViewController class]]) {
            self.loginVC = segue.destinationViewController;
            self.loginVC.welcomeScrollView = self.welcomScrollView;
        }
    }
}

#define FIRST_PIC_OFFSET_Y 20
#define FIRST_LABEL1_OFFSET_Y 10
#define FIRST_BUTTON_OFFSET_Y 40

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.welcomScrollView) {
        self.welcomeImageView1.alpha = 1 - scrollView.contentOffset.x / 320;
        
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (page == 0) {
            // 随着手指滑动，第一屏的组件向左以不同速率滑出屏外
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                self.firstPic.center = CGPointMake(self.view.center.x - scrollView.contentOffset.x, self.view.center.y - FIRST_PIC_OFFSET_Y - 30);
            } else {
                self.firstPic.center = CGPointMake(self.view.center.x - scrollView.contentOffset.x, self.view.center.y - FIRST_PIC_OFFSET_Y);
            }
            
            self.firstPic.alpha = 1 - (scrollView.contentOffset.x) / 320;
            
            self.firstButton.center = CGPointMake(160 - scrollView.contentOffset.x / 1.2, self.view.frame.size.height - FIRST_BUTTON_OFFSET_Y - 20);
            self.firstButton.alpha = 1 - (scrollView.contentOffset.x) / 320;
            self.firstPopButton.center = CGPointMake(160 - scrollView.contentOffset.x / 1.2, self.view.frame.size.height - FIRST_BUTTON_OFFSET_Y - 70);
            self.firstPopButton.alpha = 1 - (scrollView.contentOffset.x) / 320;
            
            // 登录窗口滑入
            self.loginView.alpha = scrollView.contentOffset.x / 320;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                self.loginView.center = CGPointMake(self.view.frame.size.width / 2, scrollView.contentOffset.x - 200);
            } else {
                self.loginView.center = CGPointMake(self.view.frame.size.width / 2, scrollView.contentOffset.x - 180);
                
            }
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.fifthLabel3.alpha = 0;
                self.fifthLabel3.frame = CGRectMake(20, self.view.frame.size.height + 30, 280, 30);
                self.fifthLabel1.alpha = 0;
                self.fifthLabel1.frame = CGRectMake(20, self.view.frame.size.height + 30, 280, 30);
                self.fifthLabel2.alpha = 0;
                self.fifthLabel2.frame = CGRectMake(20, self.view.frame.size.height + 30, 280, 30);
            } completion:nil];
            
            [self.view endEditing:YES];
            
        } else if (page == 1) {
            // 点了立即登录会调用这段代码
            // 滑入登录窗口
            if (self.loginView.alpha == 0) {
                self.loginView.center = CGPointMake(self.view.frame.size.width / 2, -120);
                [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.loginView.alpha = 1;
                    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                        self.loginView.center = CGPointMake(self.view.frame.size.width / 2, 120);
                    } else {
                        self.loginView.center = CGPointMake(self.view.frame.size.width / 2, 140);
                    }
                    self.fifthLabel3.alpha = 0.75;
                    self.fifthLabel3.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 150);
                    self.fifthLabel1.alpha = 0.75;
                    self.fifthLabel1.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 120);
                    self.fifthLabel2.alpha = 0.75;
                    self.fifthLabel2.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 90);
                } completion:nil];
            }
        }
    }
}

// 滑动停下来时展现动画
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page == 0) {
        self.helpPageControl.currentPage = 0;
    } else if (page == 1) {
        self.helpPageControl.currentPage = 1;
    } else if (page == 2) {
        self.helpPageControl.currentPage = 2;
    } else if (page == 3) {
        self.helpPageControl.currentPage = 3;
    }
    if (scrollView == self.welcomScrollView) {
        if (page == 1) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.fifthLabel3.alpha = 0.75;
                self.fifthLabel3.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 150);
                self.fifthLabel1.alpha = 0.75;
                self.fifthLabel1.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 120);
                self.fifthLabel2.alpha = 0.75;
                self.fifthLabel2.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 90);
            } completion:nil];
        }
    }
}

- (IBAction)instantLoginPressed:(UIButton *)sender
{
    // 缓慢滑动到登陆屏
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 隐藏所有组件
        self.firstPic.alpha = 0;
        self.firstButton.alpha = 0;
        self.firstPopButton.alpha = 0;
        // 滑动到登陆屏（scrollViewDidScroll调用page=1）
        [self.welcomScrollView scrollRectToVisible:CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height) animated:NO];
    } completion:nil];
}

- (IBAction)helpCanceled:(UIButton *)sender
{
    self.popoverVisibility = 0;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.popoverView.center = CGPointMake(self.view.center.x, 2 * self.view.frame.size.height);
        self.popoverView.alpha = 0;
    } completion:^(BOOL finished) {
            [self.popoverView removeFromSuperview];
            self.popoverView = nil;
    }];
    [UIView animateWithDuration:0.4 animations:^{
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
            [self.blackView removeFromSuperview];
            self.blackView = nil;
    }];
}

- (IBAction)helpPressed:(UIButton *)sender
{
    self.popoverVisibility = 1;
    
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [self.view addSubview:self.blackView];
    
    self.popoverView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height + 20, 280, self.view.frame.size.height - 200)];
    self.popoverView.backgroundColor = [UIColor whiteColor];
    self.popoverView.layer.cornerRadius = 15.0;
    [self.view addSubview:self.popoverView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            self.popoverView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
        } else {
            self.popoverView.center = CGPointMake(self.view.center.x, self.view.center.y - 10);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                    self.popoverView.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
                } else {
                    self.popoverView.center = CGPointMake(self.view.center.x, self.view.center.y);
                }
            } completion:^(BOOL finished) {
                if (finished) {
                    [self popoverAnimation:self.popoverView];
                }
            }];
        }
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.5;
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setFrame:CGRectMake(230, 15, 40, 30)];
    [cancel setBackgroundImage:[UIImage imageNamed:@"toolbar_item_icon_cancel_blue"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(helpCanceled:) forControlEvents:UIControlEventTouchUpInside];
    [self.popoverView addSubview:cancel];
    
    [self initHelpScrollView];
}

- (void)popoverAnimation:(UIView *)view
{
    if (self.popoverVisibility) {
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.popoverView.transform = CGAffineTransformMakeRotation(2.0/360.0);
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                self.popoverView.center = CGPointMake(158, self.view.center.y + 2 - 20);
            } else {
                self.popoverView.center = CGPointMake(158, self.view.center.y + 2);
            }
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.popoverView.transform = CGAffineTransformMakeRotation(-1.0/360.0);
                    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                        self.popoverView.center = CGPointMake(162, self.view.center.y - 20);
                    } else {
                        self.popoverView.center = CGPointMake(162, self.view.center.y);
                    }
                } completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                            self.popoverView.transform = CGAffineTransformMakeRotation(0);
                            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                                self.popoverView.center = CGPointMake(160, self.view.center.y - 2 - 20);
                            } else {
                                self.popoverView.center = CGPointMake(160, self.view.center.y - 2);
                            }
                        } completion:^(BOOL finished) {
                            if (finished) {
                                [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                                    self.popoverView.transform = CGAffineTransformMakeRotation(2.0/360.0);
                                    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                                        self.popoverView.center = CGPointMake(158, self.view.center.y + 2 - 20);
                                    } else {
                                        self.popoverView.center = CGPointMake(158, self.view.center.y + 2);
                                    }
                                } completion:^(BOOL finished) {
                                    if (finished) {
                                        [self popoverAnimation:self.popoverView];
                                    }
                                }];
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)initHelpScrollView
{
    UIScrollView *helpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 60, 260, self.popoverView.frame.size.height - 80)];
    helpScrollView.contentSize = CGSizeMake(1040, self.popoverView.frame.size.height - 80);
    helpScrollView.pagingEnabled = YES;
    helpScrollView.showsHorizontalScrollIndicator = NO;
    helpScrollView.showsVerticalScrollIndicator = NO;
    helpScrollView.delegate = self;

    self.helpPageControl = [[UIPageControl alloc] init];
    self.helpPageControl.center = CGPointMake(140, self.popoverView.frame.size.height - 20);
    self.helpPageControl.numberOfPages = 4;
    self.helpPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.helpPageControl.currentPage = 0;
    [self.popoverView addSubview:helpScrollView];
    [self.popoverView addSubview:self.helpPageControl];
    
    UITextView *helpTextView;
    if (self.view.frame.size.height <= 480) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            helpTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, -15, 260, 300)];
        } else {
            helpTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, 260, 300)];
        }
    } else {
        helpTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 30, 260, 300)];
    }
    helpTextView.text = @"       “课程助理”是一款集学业信息管理和课堂教学反馈为一体的移动教育应用软件。学生可以随堂反馈学习小结、看法感受及其他教学信息，教师根据反馈评估教学效果并及时调整教学内容和方法，从而有效提高课堂教学质量和学习体验。";
    helpTextView.textColor = [UIColor colorWithRed:0 green:123.0/255.0 blue:243.0/255.0 alpha:1];
    helpTextView.backgroundColor = [UIColor clearColor];
    helpTextView.font = [UIFont systemFontOfSize:16.0];
    helpTextView.editable = NO;
    helpTextView.userInteractionEnabled = NO;
    helpTextView.textAlignment = NSTextAlignmentLeft;
    [helpScrollView addSubview:helpTextView];
    
    UIImageView *helpImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help_pic1"]];
    if (self.view.frame.size.height <= 480) {
        helpImageView1.frame = CGRectMake(315, -15, 150, 150);
    } else {
        helpImageView1.frame = CGRectMake(315, 20, 150, 150);
    }
    [helpScrollView addSubview:helpImageView1];
    
    UILabel *helpLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(260, helpScrollView.center.y - 10, 260, 21)];
    helpLabel1.text = @"随时查看课表并自动提醒";
    helpLabel1.textColor = [UIColor colorWithRed:0 green:123.0/255.0 blue:243.0/255.0 alpha:1];
    helpLabel1.backgroundColor = [UIColor clearColor];
    helpLabel1.font = [UIFont systemFontOfSize:17.0];
    helpLabel1.textAlignment = NSTextAlignmentCenter;
    [helpScrollView addSubview:helpLabel1];
    
    UIImageView *helpImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help_pic2"]];
    if (self.view.frame.size.height <= 480) {
        helpImageView2.frame = CGRectMake(575, -15, 150, 150);
    } else {
        helpImageView2.frame = CGRectMake(575, 20, 150, 150);
    }
    [helpScrollView addSubview:helpImageView2];
    
    UILabel *helpLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(520, helpScrollView.center.y - 10, 260, 21)];
    helpLabel2.text = @"一目了然查看成绩和GPA";
    helpLabel2.textColor = [UIColor colorWithRed:0 green:123.0/255.0 blue:243.0/255.0 alpha:1];
    helpLabel2.backgroundColor = [UIColor clearColor];
    helpLabel2.font = [UIFont systemFontOfSize:17.0];
    helpLabel2.textAlignment = NSTextAlignmentCenter;
    [helpScrollView addSubview:helpLabel2];
    
    UIImageView *helpImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help_pic3"]];
    if (self.view.frame.size.height <= 480) {
        helpImageView3.frame = CGRectMake(835, -15, 150, 150);
    } else {
        helpImageView3.frame = CGRectMake(835, 20, 150, 150);
    }
    [helpScrollView addSubview:helpImageView3];
    
    UILabel *helpLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(780, helpScrollView.center.y - 10, 260, 21)];
    helpLabel3.text = @"及时向老师提供教学反馈";
    helpLabel3.textColor = [UIColor colorWithRed:0 green:123.0/255.0 blue:243.0/255.0 alpha:1];
    helpLabel3.backgroundColor = [UIColor clearColor];
    helpLabel3.font = [UIFont systemFontOfSize:17.0];
    helpLabel3.textAlignment = NSTextAlignmentCenter;
    [helpScrollView addSubview:helpLabel3];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 初始化第一屏的课程助理logo，两个label，和一个立即登陆的button
    // 全部隐藏（alpha = 0）
    self.firstPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_first_pic.png"]];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.firstPic.center = CGPointMake(-150, self.view.center.y - FIRST_PIC_OFFSET_Y - 30);
    } else {
        self.firstPic.center = CGPointMake(-150, self.view.center.y - FIRST_PIC_OFFSET_Y);
    }
    
    self.firstPic.alpha = 0;
    [self.view addSubview:self.firstPic];
    self.firstPopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstPopButton.frame = CGRectMake(0, 0, 200, 30);
    self.firstPopButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.firstPopButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.firstPopButton.alpha = 0;
    [self.firstPopButton setTitle:@"什么是课程助理？" forState:UIControlStateNormal];
    [self.firstPopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.firstPopButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    [self.firstPopButton addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstButton.frame = CGRectMake(0, 0, 100, 30);
    self.firstButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.firstButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.firstButton.alpha = 0;
    [self.firstButton setTitle:@"立即登录 >" forState:UIControlStateNormal];
    [self.firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.firstButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    [self.firstButton addTarget:self action:@selector(instantLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.firstButton];
    [self.view addSubview:self.firstPopButton];
    // 程序开启时第一屏组件以动画效果显示
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.firstPic.alpha = 1;
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            self.firstPic.center = CGPointMake(self.view.center.x, self.view.center.y - FIRST_PIC_OFFSET_Y - 30);
        } else {
            self.firstPic.center = CGPointMake(self.view.center.x, self.view.center.y - FIRST_PIC_OFFSET_Y);
        }
        
    } completion:nil];
    
    self.firstPopButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - FIRST_BUTTON_OFFSET_Y - 50);
    [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.firstPopButton.alpha = 1;
        self.firstPopButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - FIRST_BUTTON_OFFSET_Y - 70);
    } completion:nil];
    self.firstButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - FIRST_BUTTON_OFFSET_Y);
    [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.firstButton.alpha = 1;
        self.firstButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - FIRST_BUTTON_OFFSET_Y - 20);
    } completion:nil];
    
    // 初始化登陆屏（第五屏）的三个label
    self.fifthLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height + 30, 280, 30)];
    self.fifthLabel3.text = @"客服邮箱：njtechmlab@163.com";
    self.fifthLabel3.font = [UIFont boldSystemFontOfSize:12.0];
    self.fifthLabel3.textColor = [UIColor whiteColor];
    self.fifthLabel3.backgroundColor = [UIColor clearColor];
    self.fifthLabel3.textAlignment = NSTextAlignmentCenter;
    self.fifthLabel3.alpha = 0;
    self.fifthLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height + 30, 280, 30)];
    self.fifthLabel1.text = @"◉ 目前仅支持南京工业大学在籍本科生使用";
    self.fifthLabel1.font = [UIFont boldSystemFontOfSize:12.0];
    self.fifthLabel1.textColor = [UIColor whiteColor];
    self.fifthLabel1.backgroundColor = [UIColor clearColor];
    self.fifthLabel1.textAlignment = NSTextAlignmentCenter;
    self.fifthLabel1.alpha = 0;
    self.fifthLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height + 30, 280, 30)];
    self.fifthLabel2.text = @"Powered by NanjingTech M-Lab\r\nCopyright © 2014 All rights reserved";
    self.fifthLabel2.numberOfLines = 2;
    self.fifthLabel2.font = [UIFont boldSystemFontOfSize:12.0];
    self.fifthLabel2.textColor = [UIColor whiteColor];
    self.fifthLabel2.backgroundColor = [UIColor clearColor];
    self.fifthLabel2.textAlignment = NSTextAlignmentCenter;
    self.fifthLabel2.alpha = 0;
    [self.view addSubview:self.fifthLabel1];
    [self.view addSubview:self.fifthLabel2];
    [self.view addSubview:self.fifthLabel3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GPAGeniusSwitch"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"systemNotificationSwitchIsOff"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce_0.9.1"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"viewAllNewMessage"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"localNotificationIsRegistered"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"calendarOption"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIImage *img = [UIImage imageNamed:@"welcome_bg.png"];
    UIColor *collectionViewBg = [[UIColor alloc] initWithPatternImage:img];
    self.view.backgroundColor = collectionViewBg;
    
    self.welcomeImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pic_1"]];
    self.welcomeImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pic_2"]];
    self.welcomeImageView1.contentMode = UIViewContentModeCenter;
    self.welcomeImageView2.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.welcomeImageView2];
    [self.view addSubview:self.welcomeImageView1];
    
    self.welcomScrollView.contentSize = CGSizeMake(640, self.view.frame.size.height);
    self.welcomScrollView.backgroundColor = [UIColor clearColor];
    self.welcomScrollView.delegate = self;
    
    self.loginView.alpha = 0;
    self.loginView.center = CGPointMake(self.view.frame.size.width / 2, -160);
    [self.view bringSubviewToFront:self.loginView];
}

@end
