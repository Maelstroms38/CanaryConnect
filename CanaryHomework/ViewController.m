//
//  ViewController.m
//  CanaryHomework
//
//  Created by Michael Stromer on 10/18/19.
//  Copyright © 2019 Michael Stromer. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "CoreDataController.h"
#import "Device+CoreDataProperties.h"
#import "DeviceTableViewCell.h"
#import "DateFormatter.h"
#import "CoreDataManager.h"

@interface ViewController ()

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UILayoutGuide *safeArea;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Devices";
    // Do any additional setup after loading the view.
    self.safeArea = self.view.layoutMarginsGuide;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    
    // GET devices list
    [self fetchDevices];
}

- (void)fetchDevices {
    [[CoreDataController sharedCache] getAllDevices:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        if (completed) {
            [self setupFetchedResultsController];
        }
    }];
}

- (void)setupFetchedResultsController {
    CoreDataManager *coreDataManager = [CoreDataManager defaultManager];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Device" inManagedObjectContext:coreDataManager.managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entity];
    fetchRequest.sortDescriptors = [[NSArray alloc] initWithObjects: [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true], nil];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:fetchRequest
                                              managedObjectContext:coreDataManager.managedObjectContext
                                              sectionNameKeyPath:nil
                                              cacheName:nil];
    controller.delegate = self;
    self.fetchedResultsController = controller;
    NSError *error;
    BOOL success = [controller performFetch:&error];
    if (!success) {
        [self showAlert];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)showAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error Fetching Devices"
                                                                   message:@"Please check your connection and try again."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupTableView {
    self.tableView = [UITableView new];
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.tableView];
    [[self.tableView.topAnchor constraintEqualToAnchor:self.safeArea.topAnchor] setActive:true];
    [[self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:true];
    [[self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:true];
    [[self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:true];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 120;
}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

#pragma mark UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Device *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Configure the cell from the object
    cell.nameLabel.text = managedObject.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dc = [DetailViewController new];
    Device *device = [self.fetchedResultsController objectAtIndexPath:indexPath];
    dc.deviceId = device.deviceID;
    [self.navigationController pushViewController:dc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
