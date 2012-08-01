//
//  PhotosListViewController.h
//  FlickrSpots
//
//  Created by Jeffrey Yip on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrSpotsTableViewController.h"

@interface PhotosListViewController : FlickrSpotsTableViewController
@property (nonatomic, strong) NSDictionary *place;
@end
