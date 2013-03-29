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

@interface ObjectParametersViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISwitch *closedSwitch;
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

@end
