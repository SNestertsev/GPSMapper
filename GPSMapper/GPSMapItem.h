//
//  GPSMapItem.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSMapItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString* name;
// array of GPSPoint
@property (nonatomic, strong, readonly) NSMutableArray* points;
@property (nonatomic) BOOL closed;
@property (nonatomic, readonly) NSDictionary* jsonDescription;

-(id) initWithName: (NSString*) name;
-(id) initWithJSON: (NSDictionary*) json;
-(MKCoordinateRegion) getMapRegion;
-(CLLocationCoordinate2D*) getCoordinates;
-(MKMapRect) getMapRect;

@end
