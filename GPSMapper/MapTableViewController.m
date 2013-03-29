//
//  MasterViewController.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 14.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "MapTableViewController.h"
#import "ObjectViewController.h"
#import "MapParametersViewController.h"
#import "MapViewController.h"
#import "GPSMap.h"

@interface MapTableViewController ()

@property (nonatomic, strong) NSMutableArray* maps;
@property (nonatomic) NSInteger selectedRow;

@end

@implementation MapTableViewController

@synthesize maps = _maps;
@synthesize selectedRow = _selectedRow;

- (NSMutableArray*) maps
{
    if (!_maps)
        _maps = [[NSMutableArray alloc] init];
    return _maps;
}

- (void)awakeFromNib
{
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }*/
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewMap:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (MapViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewMap:(id)sender
{
    NSString* mapName = [NSString stringWithFormat:@"Map #%d", self.maps.count + 1];
    GPSMap* map = [[GPSMap alloc] initWithName: mapName];
    
    [self.maps insertObject:map atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.maps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    GPSMap *map = self.maps[indexPath.row];
    cell.textLabel.text = map.name;
    if (map.objects.count > 0)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d objects", map.objects.count];
    else
        cell.detailTextLabel.text = @"empty";
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.maps removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        GPSMap *map = self.maps[indexPath.row];
        self.detailViewController.detailItem = map;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"mapDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"mapParams"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GPSMap *map = self.maps[indexPath.row];
        MapParametersViewController* destination = [segue destinationViewController];
        destination.maps = self.maps;
        destination.map = map;
    }
    else if ([[segue identifier] isEqualToString:@"mapDetails"]) {
        GPSMap *map = self.maps[self.selectedRow];
        [[segue destinationViewController] setDetailItem:map];
    }
}

@end
