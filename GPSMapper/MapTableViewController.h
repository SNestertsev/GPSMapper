//
//  MasterViewController.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 14.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;

@interface MapTableViewController : UITableViewController

@property (strong, nonatomic) MapViewController *detailViewController;

@end
