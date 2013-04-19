//
//  MapItemAnnotation.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 19.04.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "MapItemAnnotation.h"

@implementation MapItemAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)title
{
    if (self = [super init]) {
        self.coordinate = coord;
        self.title = title;
    }
    return self;
}

@end
