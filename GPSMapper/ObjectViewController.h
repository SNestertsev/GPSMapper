//
//  DetailViewController.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 14.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPSMap;
@class GPSMapItem;

@interface ObjectViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) GPSMap* map;
@property (weak, nonatomic) GPSMapItem* objectDetails;

@end
