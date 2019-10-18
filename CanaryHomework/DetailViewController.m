//
//  DetailViewController.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UILayoutGuide *safeArea;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"About Device";
    self.safeArea = self.view.layoutMarginsGuide;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    // add readings to device
    [self fetchDeviceReadings];
    
    
}
- (void)fetchDeviceReadings {
    [self.controller getReadingsForDevice: self.device.deviceID completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        if (success && completed) {
            NSSet<Reading *> *readings = [[NSSet alloc] initWithArray:objects];
            self.device.readings = readings;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
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
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.device readings].count;
}

#pragma mark UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell from the object
    Reading *reading = [[self.device.readings allObjects] objectAtIndex:indexPath.row];
    cell.textLabel.text = reading.type;
    UILabel *tempLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 20)];
    tempLabel.text = [[NSString alloc] initWithFormat:@"%@", reading.value];
    tempLabel.textAlignment = NSTextAlignmentRight;
    cell.accessoryView = tempLabel;
    return cell;
}
@end
