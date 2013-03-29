//
//  GPSMapItem.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSMapItem : NSObject

@property (nonatomic, strong) NSString* name;

// array of GPSPoint
@property (nonatomic, strong, readonly) NSMutableArray* points;
@property (nonatomic) BOOL closed;

- (id) initWithName: (NSString*) name;

@end
