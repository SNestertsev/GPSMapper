//
//  GPSMapItem.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "GPSMapItem.h"

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

@end
