//
//  MapRepository.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 15.04.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPSMap;

@interface MapRepository : NSObject

@property (nonatomic, strong, readonly) NSMutableArray* maps;

+(MapRepository*)instance;

-(GPSMap *)getMapAtIndex:(NSInteger)index;
-(GPSMap *)getMapWithName:(NSString *)name;
-(GPSMap *)createMap;
-(void)saveMap:(GPSMap *)map;
-(void)deleteMap:(GPSMap *)map;
-(BOOL)checkMapName:(NSString *)name;

@end
