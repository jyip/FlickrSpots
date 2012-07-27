//
//  SelectedPhotoViewController.h
//  FlickrSpots
//
//  Created by terran on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPhotoViewController : UIViewController
@property (nonatomic,strong) NSDictionary *photo;
@property (nonatomic,weak) NSString *photoTitle;
@property (nonatomic, assign) BOOL setAsRecent;
@end
