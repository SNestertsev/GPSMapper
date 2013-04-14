//
//  ObjectParametersViewController.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 29.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPSMap;
@class GPSMapItem;

@interface ObjectParametersViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, weak) GPSMap* map;
@property (nonatomic, weak) GPSMapItem* object;

@end
