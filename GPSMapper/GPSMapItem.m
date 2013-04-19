//
//  GPSMapItem.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "GPSMapItem.h"
#import "GPSPoint.h"

#define kObjectNameAttribute @"objectName"
#define kIsClosedAttribute @"isClosed"
#define kPointsAttribute @"points"

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

-(id) initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        self.name = [json objectForKey:kObjectNameAttribute];
        
        NSNumber *value = [json objectForKey:kIsClosedAttribute];
        self.closed = value.boolValue;
        
        NSArray* jsonPoints = [json objectForKey:kPointsAttribute];
        for (NSDictionary* jsonPoint in jsonPoints) {
            [self.points addObject:[[GPSPoint alloc] initWithJSON:jsonPoint]];
        }
    }
    return self;
}

-(NSDictionary*)jsonDescription
{
    NSMutableArray* jsonPoints = [[NSMutableArray alloc] initWithCapacity:self.points.count];
    for (GPSPoint* point in self.points) {
        [jsonPoints addObject:point.jsonDescription];
    }
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.name, kObjectNameAttribute,
            [NSNumber numberWithBool:self.closed], kIsClosedAttribute,
            jsonPoints, kPointsAttribute,
            nil];
}

-(MKCoordinateRegion)getMapRegion
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

-(MKMapRect)getMapRect
{
    MKCoordinateRegion region = [self getMapRegion];
    MKMapRect rect = MKMapRectMake(region.center.longitude - region.span.longitudeDelta / 2.0, region.center.latitude - region.span.latitudeDelta / 2.0, region.span.longitudeDelta, region.span.latitudeDelta);
    return rect;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kObjectNameAttribute];
    [aCoder encodeBool:self.closed forKey:kIsClosedAttribute];
    [aCoder encodeObject:self.points forKey:kPointsAttribute];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:kObjectNameAttribute];
        _closed = [aDecoder decodeBoolForKey:kIsClosedAttribute];
        _points = [aDecoder decodeObjectForKey:kPointsAttribute];
    }
    return self;
}

@end
