//
//  SelectedPhotoViewController.m
//  FlickrSpots
//
//  Created by terran on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedPhotoViewController.h"
#import "FlickrFetcher.h"
#import "RecentlyViewedViewController.h"

@interface SelectedPhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation SelectedPhotoViewController

@synthesize scrollView;
@synthesize imageView;
@synthesize photo;
@synthesize photoTitle;
@synthesize setAsRecent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // get and set image
    NSURL *imageURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [imageView setImage:[UIImage imageWithData:imageData]];
    
    // set a recently viewed photo
    if (self.setAsRecent) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *recentPhotos = [[defaults valueForKey:RECENTLY_VIEWED_KEY] mutableCopy];
        if (!recentPhotos) recentPhotos = [NSMutableArray array];
        if(![recentPhotos containsObject:self.photo]) [recentPhotos insertObject:self.photo atIndex:0];
        if([recentPhotos count] > RECENT_MAX) [recentPhotos removeLastObject];
        [defaults setObject:recentPhotos forKey:RECENTLY_VIEWED_KEY];
        [defaults synchronize];
    }
    
    // set title
    self.navigationItem.title = self.photoTitle;
    
	self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

@end
