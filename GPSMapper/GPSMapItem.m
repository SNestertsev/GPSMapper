//
//  GPSMapItem.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "GPSMapItem.h"
#import "GPSPoint.h"

@implementation GPSMapItem

@synthesize name = _name;
@synthesize points = _points;
@synthesize closed = _closed;

-(NSMutableArray*) points {
    if (!_points)
        _points = [[NSMutableArray alloc] init];
    return _points;
}

- (id) initWithName: (NSString*) name {
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

-(MKCoordinateRegion)getPointsRegion
{
    MKCoordinateRegion region;
    if (self.points.count == 0) {
        return region;
    }
    
    GPSPoint* point = [self.points objectAtIndex:0];
    CLLocationDegrees minLat = point.latitude;
    CLLocationDegrees maxLat = point.latitude;
    CLLocationDegrees minLong = point.longitude;
    CLLocationDegrees maxLong = point.longitude;
    double miles = 0.2; // default region size
    double scalingFactor = ABS( cos(2 * M_PI * minLat / 360.0));
    MKCoordinateSpan span;
    
    if (self.points.count > 1) {
        for (int i = 1; i < self.points.count; i++) {
            point = [self.points objectAtIndex:i];
            if (point.latitude < minLat) {
                minLat = point.latitude;
            }
            if (point.latitude > maxLat) {
                maxLat = point.latitude;
            }
            if (point.longitude < minLong) {
                minLong = point.longitude;
            }
            if (point.longitude > maxLong) {
                maxLong = point.longitude;
            }
        }
        span.latitudeDelta = (maxLat - minLat) * 1.1;
        if (span.latitudeDelta < miles / 69.0) {
            span.latitudeDelta = miles / 69.0;
        }
        span.longitudeDelta = (maxLong - minLong) * 1.1;
        if (span.longitudeDelta < miles / (scalingFactor * 69.0)) {
            span.longitudeDelta = miles / (scalingFactor * 69.0);
        }
        region.center = CLLocationCoordinate2DMake(minLat + (maxLat - minLat) / 2, minLong + (maxLong - minLong) / 2);
    }
    else {
        span.latitudeDelta = miles / 69.0;
        span.longitudeDelta = miles / (scalingFactor * 69.0);
        region.center = CLLocationCoordinate2DMake(minLat, minLong);
    }
    region.span = span;
    
    return region;
}

-(CLLocationCoordinate2D *)getCoordinates
{
    if (self.points.count == 0) {
        return NULL;
    }
    
    CLLocationCoordinate2D* result = malloc(sizeof(CLLocationCoordinate2D) * self.points.count);
    for (int i = 0; i < self.points.count; i++) {
        GPSPoint* point = [self.points objectAtIndex:i];
        result[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
    }
    return result;
}

@end
