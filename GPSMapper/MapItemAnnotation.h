//
//  MapItemAnnotation.h
//  GPSMapper
//
//  Created by Sergey Nestertsev on 19.04.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapItemAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString*)title;

@end
