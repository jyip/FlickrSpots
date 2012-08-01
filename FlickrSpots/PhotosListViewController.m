//
//  PhotosListViewController.m
//  FlickrSpots
//
//  Created by Jeffrey Yip on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosListViewController.h"
#import "SelectedPhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotosListViewController ()

@end

@implementation PhotosListViewController

@synthesize place = _place;

- (void)setPlace:(NSDictionary *)place
{
    if(_place != place) {
        _place = place;
        [self updatePhotosInPlace];
    }
}

#define PHOTOS_LIST_MAX 50
- (void)updatePhotosInPlace
{
    NSString *placeInfo = [self.place valueForKey:FLICKR_PLACE_NAME];
    self.navigationItem.title = [placeInfo substringToIndex:[placeInfo rangeOfString:@", "].location];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        // get photosList with fetcher in separate queue thread
        NSArray *photosList = [FlickrFetcher photosInPlace:self.place maxResults:PHOTOS_LIST_MAX];
        // go back to main queue to set flickrData which has UIKit elements 
        dispatch_async(dispatch_get_main_queue(), ^{
            self.flickrData = photosList;
        });
    });
    dispatch_release(downloadQueue);
    //NSLog(@"%@", self.flickrData);
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
    static NSString *CellIdentifier = @"Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *title = [[self.flickrData objectAtIndex:indexPath.row] valueForKey:FLICKR_PHOTO_TITLE];
    NSString *desc = [[self.flickrData objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        
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
    if ([segue.identifier isEqualToString:@"Show Photo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *photo = [self.flickrData objectAtIndex:indexPath.row];
        [segue.destinationViewController setPhoto:photo];
        [segue.destinationViewController setPhotoTitle:[sender text]];
        [segue.destinationViewController setSetAsRecent:YES];
    }
}

@end
