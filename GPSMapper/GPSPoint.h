//
//  GPSPoint.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 29.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSPoint : NSObject <NSCoding>

@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic, readonly) NSDictionary* jsonDescription;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
-(id)initWithLongitute:(CLLocationDegrees)longitude andLatitude:(CLLocationDegrees)latitude;
-(id)initWithJSON:(NSDictionary*)json;
-(CLLocationCoordinate2D)getCoordinate;

@end
