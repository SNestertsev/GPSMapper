//
//  GPSPoint.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 29.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "GPSPoint.h"

@implementation GPSPoint

@synthesize longitude = _longitude;
@synthesize latitude = _latitude;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        self.longitude = coordinate.longitude;
        self.latitude = coordinate.latitude;
    }
    return self;
}

-(id)initWithLongitute:(CLLocationDegrees)longitude andLatitude:(CLLocationDegrees)latitude
{
    if (self = [super init]) {
        self.longitude = longitude;
        self.latitude = latitude;
    }
    return self;
}

-(CLLocationCoordinate2D)getCoordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
