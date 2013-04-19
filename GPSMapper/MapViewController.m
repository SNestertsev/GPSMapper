//
//  ObjectTableViewController.m
//  GPSMapper
//
//  Created by Sergey Nestertsev on 26.03.13.
//  Copyright (c) 2013 Sergey Nestertsev. All rights reserved.
//

#import "MapViewController.h"
#import "ObjectParametersViewController.h"
#import "ObjectViewController.h"
#import "GPSMap.h"
#import "GPSMapItem.h"
#import "MapRepository.h"

@interface MapViewController ()

@property (nonatomic) NSInteger selectedRow;

@end

@implementation MapViewController

@synthesize selectedRow = _selectedRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(GPSMap*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    //if (self.masterPopoverController != nil) {
     //   [self.masterPopoverController dismissPopoverAnimated:YES];
    //}
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.title = self.detailItem.name;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
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

- (void)insertNewObject:(id)sender
{
    NSString* objectName = [NSString stringWithFormat:@"Object #%d", self.detailItem.objects.count + 1];
    GPSMapItem* object = [[GPSMapItem alloc] initWithName: objectName];
    
    [self.detailItem.objects insertObject:object atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [[MapRepository instance] saveMap:self.detailItem];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.detailItem.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    GPSMapItem *object = self.detailItem.objects[indexPath.row];
    cell.textLabel.text = object.name;
    if (object.points.count > 0)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d points", object.points.count];
    else
        cell.detailTextLabel.text = @"empty";
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"objectDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"objectParams"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GPSMapItem *object = self.detailItem.objects[indexPath.row];
        ObjectParametersViewController* destination = [segue destinationViewController];
        destination.map = self.detailItem;
        destination.object = object;
    }
    else if ([[segue identifier] isEqualToString:@"objectDetails"]) {
        GPSMapItem *object = self.detailItem.objects[self.selectedRow];
        ObjectViewController* destination = [segue destinationViewController];
        destination.map = self.detailItem;
        destination.objectDetails = object;
    }
}

@end
