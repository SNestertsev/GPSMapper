//
//  GPSPoint.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 29.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "GPSPoint.h"

#define kLongitudeAttribute @"longitude"
#define kLatitudeAttribute @"latitude"

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

-(id)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        NSNumber* value = [json objectForKey:kLongitudeAttribute];
        self.longitude = value.doubleValue;
        
        value = [json objectForKey:kLatitudeAttribute];
        self.latitude = value.doubleValue;
    }
    return self;
}

-(NSDictionary*)jsonDescription
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithDouble:self.longitude], kLongitudeAttribute,
            [NSNumber numberWithDouble:self.latitude], kLatitudeAttribute,
            nil];
}

-(CLLocationCoordinate2D)getCoordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.longitude forKey:kLongitudeAttribute];
    [aCoder encodeDouble:self.latitude forKey:kLatitudeAttribute];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _longitude = [aDecoder decodeDoubleForKey:kLongitudeAttribute];
        _latitude = [aDecoder decodeDoubleForKey:kLatitudeAttribute];
    }
    return self;
}

@end
