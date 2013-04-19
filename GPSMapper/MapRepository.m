//
//  MapRepository.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 15.04.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "MapRepository.h"
#import "GPSMap.h"

@interface MapRepository()
-(void)insertMap:(GPSMap *)map;
@end

@implementation MapRepository

@synthesize maps = _maps;

+(MapRepository *)instance
{
    static MapRepository* repository = nil;
    if (!repository) {
        repository = [[MapRepository alloc] init];
    }
    return repository;
}

-(id)init
{
    if (self = [super init]) {
        _maps = [[NSMutableArray alloc] init];
        
        NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [arrayPaths objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *arrayFiles = [fileManager contentsOfDirectoryAtPath:docDirectory error:nil];
        for (int i = 0; i < arrayFiles.count; i++) {
            NSString *fileName = [docDirectory stringByAppendingPathComponent:[arrayFiles objectAtIndex:i]];
            if (![fileName.pathExtension isEqualToString:@"json"]) continue;
            
            NSData* data = [NSData dataWithContentsOfFile:fileName];
            NSError *err;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions 
                                  error:&err];
            if (!json) continue;
            [self insertMap:[[GPSMap alloc] initWithJSON:json]];
        }
    }
    return self;
}

// Adds a map to repository sorted by creation date
-(void)insertMap:(GPSMap *)map
{
    if (!map) return;
    for (int i = 0; i < self.maps.count; i++) {
        GPSMap *m = [self.maps objectAtIndex:i];
        if (map.creationDate < m.creationDate) {
            [self.maps insertObject:map atIndex:i];
            return;
        }
    }
    [self.maps addObject:map];
}

-(GPSMap *)getMapAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.maps.count)
        return nil;
    
    return self.maps[self.maps.count - index - 1];
}

-(GPSMap *)getMapWithName:(NSString *)name
{
    for (GPSMap* map in self.maps) {
        if (map.name == name) {
            return map;
        }
    }
    return nil;
}

-(GPSMap *)createMap
{
    NSString* mapName;
    int mapNumber = 1;
    do {
        mapName = [NSString stringWithFormat:@"Map #%d", mapNumber++];
    } while (![self checkMapName:mapName]);
    
    GPSMap* map = [[GPSMap alloc] initWithName: mapName];
    map.creationDate = [NSDate date];
    [self.maps addObject:map];
    [self saveMap:map];
    return map;
}

-(void)saveMap:(GPSMap *)map
{
    if (![self.maps containsObject:map]) {
        [self.maps insertObject:map atIndex:0];
    }
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *originalFileName = [[docDirectory stringByAppendingPathComponent:map.originalName] stringByAppendingPathExtension:@"json"];
    NSString *fileName = [[docDirectory stringByAppendingPathComponent:map.name] stringByAppendingPathExtension:@"json"];
    // Delete old file, if the map name was modified
    if (![originalFileName isEqualToString:fileName] && [fileManager fileExistsAtPath:originalFileName]) {
        [fileManager removeItemAtPath:originalFileName error:nil];
    }
    NSError *error;
    NSData *mapData = [NSJSONSerialization dataWithJSONObject:map.jsonDescription options:NSJSONWritingPrettyPrinted error:&error];
    [mapData writeToFile:fileName atomically:YES];
    map.originalName = map.name;
}

-(void)deleteMap:(GPSMap *)map
{
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[docDirectory stringByAppendingPathComponent:map.name] stringByAppendingPathExtension:@"json"];
    if ([fileManager fileExistsAtPath:fileName]) {
        [fileManager removeItemAtPath:fileName error:nil];
    }
    
    [self.maps removeObject:map];
}

-(BOOL)checkMapName:(NSString *)name
{
    if (name.length == 0)
        return NO;
    
    for (GPSMap* map in self.maps) {
        if ([map.name isEqualToString:name]) {
            return NO;
        }
    }
    return YES;
}

@end
