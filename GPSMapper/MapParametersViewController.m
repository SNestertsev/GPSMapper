//
//  MapParametersViewController.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 26.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "MapParametersViewController.h"
#import "GPSMap.h"

@interface MapParametersViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapParametersViewController

@synthesize maps = _maps;
@synthesize map = _map;
@synthesize nameField = _nameField;
@synthesize mapView = _mapView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.nameField.text.length > 0)
        self.map.name = self.nameField.text;
}

- (void)deleteMap:(id)sender {
    [self.maps removeObject:self.map];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
