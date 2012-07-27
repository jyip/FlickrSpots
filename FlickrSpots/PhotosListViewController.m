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
@synthesize photosList = _photosList;

#define PHOTOS_LIST_MAX 50
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *placeInfo = [self.place valueForKey:@"_content"];
    self.navigationItem.title = [placeInfo substringToIndex:[placeInfo rangeOfString:@", "].location];
    self.photosList = [FlickrFetcher photosInPlace:self.place maxResults:PHOTOS_LIST_MAX];
    
    //NSLog(@"%@",self.photosList);
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
    return [self.photosList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *title = [[self.photosList objectAtIndex:indexPath.row] valueForKey:@"title"];
    NSString *desc = [[self.photosList objectAtIndex:indexPath.row] valueForKeyPath:@"description._content"];
        
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
        NSDictionary *photo = [self.photosList objectAtIndex:indexPath.row];
        [segue.destinationViewController setPhoto:photo];
        [segue.destinationViewController setPhotoTitle:[sender text]];
    }
}

@end
