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
@property (nonatomic, strong) NSArray *topFlickrPlaces;
@end

@implementation TopPlacesViewController

@synthesize topFlickrPlaces = _topFlickrPlaces;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // sort to alpha by first letter of _content
    NSArray *sortedArray;
    sortedArray = [[FlickrFetcher topPlaces] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(NSArray*)a valueForKey:@"_content"];
        NSString *second = [(NSArray*)b valueForKey:@"_content"];
        return [first compare:second];
    }];
    self.topFlickrPlaces = sortedArray;
    
    //NSLog(@"%@", self.topFlickrPlaces);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [self.topFlickrPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Location Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *placeInfo = [[self.topFlickrPlaces objectAtIndex:indexPath.row] valueForKey:@"_content"];
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
        NSDictionary *place = [self.topFlickrPlaces objectAtIndex:indexPath.row];
        [segue.destinationViewController setPlace:place];
    }
}

@end
