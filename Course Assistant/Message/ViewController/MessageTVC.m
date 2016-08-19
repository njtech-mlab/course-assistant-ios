//
//  MessageTVC.m
//  课程助理
//
//  Created by Jason J on 13-4-15.
//  Copyright (c) 2013年 Ji WenTian. All rights reserved.
//

#import "MessageTVC.h"
#import "MessageTableViewCell.h"
#import "ECSlidingViewController.h"
#import "UIBarButtonItem+Custom.h"

@interface MessageTVC () <UINavigationBarDelegate>

@end

@implementation MessageTVC
/*
@synthesize managedDocumentHandlerDelegate = _managedDocumentHandlerDelegate;

- (id <UIManagedDocumentHandlerDelegate>)managedDocumentHandlerDelegate
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if(!_managedDocumentHandlerDelegate && [appDelegate conformsToProtocol: @protocol(UIManagedDocumentHandlerDelegate)]) {
        return appDelegate;
    }
    return _managedDocumentHandlerDelegate;
}

- (CoreDataTableViewController *)CDTVC
{
    if (!_CDTVC) {
        _CDTVC = [[CoreDataTableViewController alloc] init];
    }
    return _CDTVC;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.CDTVC.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.CDTVC.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.CDTVC.fetchedResultsController objectAtIndexPath:indexPath];
    
    CGFloat height = [[managedObject valueForKey:@"title"] sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(244, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + [[managedObject valueForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(244, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + 30;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSManagedObject *managedObject = [self.CDTVC.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    cell.messageCellTitle.text = [managedObject valueForKey:@"title"];
    cell.messageCellContentLabel.frame = CGRectMake(56, 34, 244, 2008);
    [cell layoutIfNeeded];
    cell.messageCellContentLabel.text = [managedObject valueForKey:@"content"];
    cell.messageCellContentLabel.font = [UIFont systemFontOfSize:14.0];
    cell.messageCellContentLabel.backgroundColor = [UIColor clearColor];
    cell.messageCellContentLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    cell.messageCellContentLabel.numberOfLines = 0;
    [cell.messageCellContentLabel sizeToFit];
    
    UIImage *messageIcon = [UIImage imageNamed:@"message_system_icon.png"];
    cell.messageIconView.image = messageIcon;
    cell.messageIconView.frame = CGRectMake(20, 6, 30, 30);
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)];
    view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 68, 20)];
    dateLabel.textColor = [UIColor darkGrayColor];
    dateLabel.font = [UIFont boldSystemFontOfSize:12.0];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:dateLabel];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.CDTVC.fetchedResultsController sections] objectAtIndex:section];
    dateLabel.text = [sectionInfo name];
    
    return view;
}
*/

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (IBAction)navButtonPressed:(UIBarButtonItem *)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *messageComingSoon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_coming_soon"]];
    [self.tableView addSubview:messageComingSoon];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{ UITextAttributeFont : [UIFont systemFontOfSize:17.0], UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowColor : [UIColor clearColor], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero] };
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    // Set button items on tool bar
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] description] length] > 5) {
        UIImage *barButtonImage = [UIImage imageNamed:@"toolbar_nav_icon.png"];
        UIBarButtonItem *nav = [[UIBarButtonItem alloc] init];
        nav = [UIBarButtonItem barItemWithImage:barButtonImage
                                         target:self
                                         action:@selector(navButtonPressed:)
                                     edgeInsets:UIEdgeInsetsZero
                                          width:barButtonImage.size.width
                                         height:barButtonImage.size.height];
        self.navigationItem.leftBarButtonItem = nav;
    }
}

@end
