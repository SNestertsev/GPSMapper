//
//  GPSMap.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "GPSMap.h"
#import "GPSMapItem.h"
#import "GPSPoint.h"

#define kMapNameAttribute @"mapName"
#define kMapCreationDateAttribute @"creationDate"
#define kDateFormat @"yyyy-MM-dd HH:mm:ss"
#define kMapObjectsArrayAttribute @"objects"


@implementation GPSMap

@synthesize originalName = _originalName;
@synthesize name = _name;
@synthesize objects = _objects;
@synthesize creationDate = _creationDate;

-(NSMutableArray*) objects
{
    if (!_objects)
        _objects = [[NSMutableArray alloc] init];
    return _objects;
}

- (id) initWithName: (NSString*) name
{
    if (self = [super init]) {
        self.originalName = name;
        self.name = name;
    }
    return self;
}

-(id)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        self.name = [json objectForKey:kMapNameAttribute];
        self.originalName = self.name;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:kDateFormat];
        self.creationDate = [dateFormatter dateFromString:[json objectForKey:kMapCreationDateAttribute]];
        NSArray* jsonObjects = [json objectForKey:kMapObjectsArrayAttribute];
        for (NSDictionary* jsonObject in jsonObjects) {
            [self.objects addObject:[[GPSMapItem alloc] initWithJSON:jsonObject]];
        }
    }
    return self;
}

-(NSDictionary*)jsonDescription
{
    NSMutableArray* jsonObjects = [[NSMutableArray alloc] initWithCapacity:self.objects.count];
    for (GPSMapItem *object in self.objects) {
        [jsonObjects addObject:object.jsonDescription];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.name, kMapNameAttribute,
            [dateFormatter stringFromDate:self.creationDate], kMapCreationDateAttribute,
            jsonObjects, kMapObjectsArrayAttribute,
            nil];
}

-(MKCoordinateRegion)getMapRegion
{
    MKCoordinateRegion region;
    if (self.objects.count == 0) {
        return region;
    }
    
    MKMapRect rect = [[self.objects objectAtIndex:0] getMapRect];
    if (self.objects.count > 1) {
        for (int i = 1; i < self.objects.count; i++) {
            MKMapRect objectRect = [[self.objects objectAtIndex:i] getMapRect];
            rect = MKMapRectUnion(rect, objectRect);
        }
    }
    MKCoordinateSpan span;
    span.longitudeDelta = rect.size.width;
    span.latitudeDelta = rect.size.height;
    region.span = span;
    region.center = CLLocationCoordinate2DMake(MKMapRectGetMidY(rect), MKMapRectGetMidX(rect));
    return region;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kMapNameAttribute];
    [aCoder encodeObject:self.creationDate forKey:kMapCreationDateAttribute];
    [aCoder encodeObject:self.objects forKey:kMapObjectsArrayAttribute];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:kMapNameAttribute];
        _creationDate = [aDecoder decodeObjectForKey:kMapCreationDateAttribute];
        _objects = [aDecoder decodeObjectForKey:kMapObjectsArrayAttribute];
    }
    return self;
}

@end
