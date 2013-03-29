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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPoint {
    GPSPoint* point = [[GPSPoint alloc] initWithCoordinate:self.locationManager.location.coordinate];
    [self.objectDetails.points addObject:point];
}

- (IBAction)closedSwitchChanged:(id)sender {
    self.objectDetails.closed = self.closedSwitch.on;
    self.addPointButton.hidden = self.objectDetails.closed;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = self.locationManager.location;
    self.accuracyField.text = [NSString stringWithFormat:@"%f meters", location.horizontalAccuracy];
    self.longitudeField.text = [NSString stringWithFormat:@"%f degrees", location.coordinate.longitude];
    self.latitudeField.text = [NSString stringWithFormat:@"%f degrees", location.coordinate.latitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorLocationUnknown) {
        // ignore
    }
    else if (error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    }
}

@end
