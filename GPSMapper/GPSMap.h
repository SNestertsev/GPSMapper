//
//  GPSMap.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 23.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSMap : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong, readonly) NSMutableArray* objects;

- (id) initWithName: (NSString*) name;

@end
