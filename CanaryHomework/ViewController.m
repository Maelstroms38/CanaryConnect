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

@interface ViewController ()

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UILayoutGuide *safeArea;
@property(nonatomic, strong) CoreDataController *controller;
@property (nullable, nonatomic, retain) NSArray<Device *> *devices;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Devices";
    // Do any additional setup after loading the view.
    self.safeArea = self.view.layoutMarginsGuide;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    
    // Initialize the controller
    CoreDataController *controller = [[CoreDataController alloc] init];
    self.controller = controller;
    // GET devices list
    [self fetchDevices];
}

- (void)fetchDevices {
    [self.controller getAllDevices:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        if (success && completed) {
            NSArray<Device *> *devices = objects;
            self.devices = devices;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
                
//            [self.controller getReadingsForDevice: device.deviceID completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
//
//                if (success && completed) {
//                    NSSet<Reading *> *readings = [[NSSet alloc] initWithObjects:objects, nil];
//                    device.readings = readings;
//
//                }
//            
//            }];

        } else {
            [self showAlert];
        }
    }];
    
    
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
//    [self.tableView registerClass:[DeviceTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 120;
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self devices].count;
}

#pragma mark UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Device *object = [self.devices objectAtIndex:indexPath.row];
    
    // Configure the cell from the object
    
    cell.nameLabel.text = object.name;
    
    
    cell.tempLabel.text = [[DateFormatter sharedFormatter] stringFromDate:object.updateAt];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dc = [DetailViewController new];
    dc.device = [self.devices objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dc animated:YES];
}

@end
