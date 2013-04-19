//
//  MapParametersViewController.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 26.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "MapParametersViewController.h"
#import "GPSMap.h"
#import "GPSMapItem.h"
#import "GPSPoint.h"
#import "MapRepository.h"
#import "MapItemAnnotation.h"

@interface MapParametersViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *noObjectsLabel;
@property (nonatomic) BOOL isDeletedMap;

@end

@implementation MapParametersViewController

@synthesize map = _map;
@synthesize nameField = _nameField;
@synthesize mapView = _mapView;
@synthesize isDeletedMap = _isDeletedMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.nameField.text = self.map.name;
    
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteMap:)];
    self.navigationItem.rightBarButtonItem = trashButton;
    self.isDeletedMap = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.map.objects.count > 0) {
        for (int i = 0; i < self.map.objects.count; i++) {
            [self addOverlayAndAnnotationForObject:[self.map.objects objectAtIndex:i]];
        }
    }
    else {
        self.noObjectsLabel.hidden = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    if (self.map.objects.count > 0) {
        [self.mapView setRegion:self.map.getMapRegion animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.isDeletedMap)
        return;
    
    MapRepository *mapRepository = [MapRepository instance];
    if (self.nameField.text.length > 0 && [mapRepository checkMapName:self.nameField.text]) {
         self.map.name = self.nameField.text;
        [mapRepository saveMap:self.map];
    }
}

- (void)deleteMap:(id)sender {
    [[MapRepository instance] deleteMap:self.map];
    self.isDeletedMap = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addOverlayAndAnnotationForObject:(GPSMapItem*)object
{
    id<MKOverlay> mapOverlayObject;
    if (object.points.count > 0) {
        if (object.points.count == 1) {
            GPSPoint *point = [object.points objectAtIndex:0];
            mapOverlayObject = [MKCircle circleWithCenterCoordinate:[point getCoordinate] radius:1.0];
        }
        else {
            if (object.closed) {
                mapOverlayObject = [MKPolygon polygonWithCoordinates:object.getCoordinates count:object.points.count];
            }
            else {
                mapOverlayObject = [MKPolyline polylineWithCoordinates:object.getCoordinates count:object.points.count];
            }
        }
        [self.mapView addOverlay:mapOverlayObject];
        
        GPSPoint *point = [object.points objectAtIndex:0];
        MapItemAnnotation *annotation = [[MapItemAnnotation alloc] initWithCoordinate:point.getCoordinate andTitle:object.name];
        [self.mapView addAnnotation:annotation];
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

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (![[MapRepository instance] checkMapName:textField.text]) {
        return NO;
    }
    return YES;
}

@end
