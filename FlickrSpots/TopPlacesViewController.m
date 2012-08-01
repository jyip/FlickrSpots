//
//  TopPlacesViewController.m
//  FlickrSpots
//
//  Created by terran on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"
#import "PhotosListViewController.h"

@interface TopPlacesViewController ()

@end

@implementation TopPlacesViewController

- (void)updateTopPlaces
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        // use flickr fetcher and sort
        NSArray *topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(NSArray*)a valueForKey:FLICKR_PLACE_NAME];
            NSString *second = [(NSArray*)b valueForKey:FLICKR_PLACE_NAME];
            return [first compare:second];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.flickrData = topPlaces;
        });
    });
    dispatch_release(downloadQueue);
    //NSLog(@"%@", self.flickrData);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTopPlaces];
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
    return [self.flickrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Location Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *placeInfo = [[self.flickrData objectAtIndex:indexPath.row] valueForKey:FLICKR_PLACE_NAME];
    cell.textLabel.text = [placeInfo substringToIndex:[placeInfo rangeOfString:@", "].location];
    cell.detailTextLabel.text = [placeInfo substringFromIndex:[placeInfo rangeOfString:@", "].location+2];

    return cell;
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos List"]) {
        // get photos list from flickr
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *place = [self.flickrData objectAtIndex:indexPath.row];
        [segue.destinationViewController setPlace:place];
    }
}

@end
