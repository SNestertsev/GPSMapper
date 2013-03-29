//
//  GPSMap.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "GPSMap.h"

@implementation GPSMap

@synthesize name = _name;
@synthesize objects = _objects;

-(NSMutableArray*) objects {
    if (!_objects)
        _objects = [[NSMutableArray alloc] init];
    return _objects;
}

- (id) initWithName: (NSString*) name {
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

@end
