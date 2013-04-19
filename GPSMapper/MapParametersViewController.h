//
//  MapParametersViewController.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 26.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPSMap;
@class MapRepository;

@interface MapParametersViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) GPSMap* map;

@end
