//
//  GPSMap.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSMap : NSObject <NSCoding>

@property (nonatomic, strong) NSString* originalName;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong, readonly) NSMutableArray* objects;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, readonly) NSDictionary* jsonDescription;

-(id)initWithName: (NSString*) name;
-(id)initWithJSON: (NSDictionary*) json;
-(MKCoordinateRegion) getMapRegion;

@end
