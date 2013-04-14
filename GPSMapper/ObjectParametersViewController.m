//
//  ObjectParametersViewController.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 29.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "ObjectParametersViewController.h"
#import "GPSMap.h"
#import "GPSMapItem.h"
#import "GPSPoint.h"

@interface ObjectParametersViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISwitch *closedSwitch;
@property (weak, nonatomic) IBOutlet UILabel *noPointsLabel;

@property (nonatomic) id mapOverlayObject;      // MKPolygon or MKPolyline
@end

@implementation ObjectParametersViewController

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
    self.nameField.text = self.object.name;
    self.closedSwitch.on = self.object.closed;
    self.closedSwitch.enabled = NO;
    
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteObject:)];
    self.navigationItem.rightBarButtonItem = trashButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.object.points.count > 0) {
        [self.mapView setRegion:self.object.getPointsRegion animated:NO];
        if (self.object.points.count == 1) {
            GPSPoint *point = [self.object.points objectAtIndex:0];
            self.mapOverlayObject = [MKCircle circleWithCenterCoordinate:[point getCoordinate] radius:1.0];
        }
        else {
            if (self.object.closed) {
                self.mapOverlayObject = [MKPolygon polygonWithCoordinates:self.object.getCoordinates count:self.object.points.count];
            }
            else {
                self.mapOverlayObject = [MKPolyline polylineWithCoordinates:self.object.getCoordinates count:self.object.points.count];
            }
        }
        [self.mapView addOverlay:self.mapOverlayObject];
    }
    else {
        self.noPointsLabel.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.nameField.text.length > 0)
        self.object.name = self.nameField.text;
    self.object.closed = self.closedSwitch.selected;
}

- (void)deleteObject:(id)sender {
    [self.map.objects removeObject:self.object];
    [self.navigationController popViewControllerAnimated:YES];
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
