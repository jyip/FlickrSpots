//
//  RecentlyViewedViewController.m
//  FlickrSpots
//
//  Created by Jeffrey Yip on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentlyViewedViewController.h"
#import "SelectedPhotoViewController.h"

@interface RecentlyViewedViewController ()
@property (nonatomic,strong) NSArray *recentPhotos;
@end

@implementation RecentlyViewedViewController

@synthesize recentPhotos;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.recentPhotos = [defaults valueForKey:RECENTLY_VIEWED_KEY];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.recentPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *title = [[self.recentPhotos objectAtIndex:indexPath.row] valueForKey:@"title"];
    NSString *desc = [[self.recentPhotos objectAtIndex:indexPath.row] valueForKeyPath:@"description._content"];
    
    if([title length] == 0 && [desc length] == 0) {
        cell.textLabel.text = @"Unknown";
    }
    else if([title length] == 0) {
        cell.textLabel.text = desc;
    } 
    else {
        cell.textLabel.text = title;
        cell.detailTextLabel.text = desc;
    }
    
    return cell;
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Recent Photo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *photo = [self.recentPhotos objectAtIndex:indexPath.row];
        [segue.destinationViewController setPhoto:photo];
        [segue.destinationViewController setPhotoTitle:[sender text]];
    }
}

@end
