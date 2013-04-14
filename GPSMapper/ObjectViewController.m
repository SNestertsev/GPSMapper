//
//  DetailViewController.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 14.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "ObjectViewController.h"
#import "GPSMapItem.h"
#import "GPSPoint.h"

@interface ObjectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *accuracyField;
@property (weak, nonatomic) IBOutlet UILabel *longitudeField;
@property (weak, nonatomic) IBOutlet UILabel *latitudeField;
@property (weak, nonatomic) IBOutlet UIButton *addPointButton;
@property (weak, nonatomic) IBOutlet UISwitch *closedSwitch;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic) BOOL isRegionInitialized;
@property (nonatomic) id mapOverlayObject;      // MKPolygon or MKPolyline
@end

@implementation ObjectViewController

@synthesize objectDetails = _objectDetails;
@synthesize accuracyField = _accuracyField;
@synthesize longitudeField = _longitudeField;
@synthesize latitudeField = _latitudeField;
@synthesize locationManager = _locationManager;

- (CLLocationManager*) locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isRegionInitialized = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.objectDetails.name;
    self.closedSwitch.on = self.objectDetails.closed;
    self.addPointButton.hidden = self.objectDetails.closed;
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.distanceFilter = 1;
        [self.locationManager startUpdatingLocation];
    }

    [self updateOverlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPoint
{
    GPSPoint* point = [[GPSPoint alloc] initWithCoordinate:self.locationManager.location.coordinate];
    [self.objectDetails.points addObject:point];
    [self updateOverlay];
}

- (IBAction)closedSwitchChanged:(id)sender
{
    self.objectDetails.closed = self.closedSwitch.on;
    self.addPointButton.hidden = self.objectDetails.closed;
    [self updateOverlay];
}

- (void)updateOverlay
{
    if (self.mapOverlayObject != NULL) {
        [self.mapView removeOverlay:self.mapOverlayObject];
        self.mapOverlayObject = NULL;
    }
    
    if (self.objectDetails.points.count > 0) {
        [self.mapView setRegion:self.objectDetails.getPointsRegion animated:NO];
        self.isRegionInitialized = YES;
        
        if (self.objectDetails.points.count == 1) {
            GPSPoint *point = [self.objectDetails.points objectAtIndex:0];
            self.mapOverlayObject = [MKCircle circleWithCenterCoordinate:[point getCoordinate] radius:1.0];
        }
        else {
            if (self.objectDetails.closed) {
                self.mapOverlayObject = [MKPolygon polygonWithCoordinates:self.objectDetails.getCoordinates count:self.objectDetails.points.count];
            }
            else {
                self.mapOverlayObject = [MKPolyline polylineWithCoordinates:self.objectDetails.getCoordinates count:self.objectDetails.points.count];
            }
            [self.mapView addOverlay:self.mapOverlayObject];
        }
    }
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = self.locationManager.location;
    self.accuracyField.text = [NSString stringWithFormat:@"%f meters", location.horizontalAccuracy];
    self.longitudeField.text = [NSString stringWithFormat:@"%f degrees", location.coordinate.longitude];
    self.latitudeField.text = [NSString stringWithFormat:@"%f degrees", location.coordinate.latitude];
    
    if (!self.isRegionInitialized) {
        double miles = 0.2;
        double scalingFactor = ABS( cos(2 * M_PI * location.coordinate.latitude / 360.0));
        MKCoordinateSpan span;
        span.latitudeDelta = miles / 69.0;
        span.longitudeDelta = miles / (scalingFactor * 69.0);
        MKCoordinateRegion region;
        region.span = span;
        region.center = location.coordinate;
        [self.mapView setRegion:region animated:NO];
        self.isRegionInitialized = YES;
    }
    else {
        MKCoordinateRegion region = self.mapView.region;
        region.center = location.coordinate;
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorLocationUnknown) {
        // ignore
    }
    else if (error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark MKMapViewDelegate
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKOverlayPathView *overlayView;
    
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygon *polygon = overlay;
        overlayView = [[MKPolygonView alloc] initWithPolygon:polygon];
    }
    else if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyline = overlay;
        overlayView = [[MKPolylineView alloc] initWithPolyline:polyline];
    }
    else if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircle *circle = overlay;
        overlayView = [[MKCircleView alloc] initWithCircle:circle];
    }
    overlayView.fillColor = [UIColor blueColor];
    overlayView.strokeColor = [UIColor blueColor];
    overlayView.alpha = 0.5;
    
    return overlayView;
}

@end
