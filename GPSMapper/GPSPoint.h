//
//  GPSPoint.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 29.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSPoint : NSObject

@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) CLLocationDegrees latitude;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithLongitute:(CLLocationDegrees)longitude andLatitude:(CLLocationDegrees)latitude;

@end
