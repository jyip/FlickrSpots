//
//  RecentlyViewedViewController.m
//  FlickrSpots
//
//  Created by Jeffrey Yip on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentlyViewedViewController.h"
#import "SelectedPhotoViewController.h"
#import "FlickrFetcher.h"

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
    // update the list whenever this view is about to reappear
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.recentPhotos = [defaults valueForKey:RECENTLY_VIEWED_KEY];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    
    NSString *title = [[self.recentPhotos objectAtIndex:indexPath.row] valueForKey:FLICKR_PHOTO_TITLE];
    NSString *desc = [[self.recentPhotos objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
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
