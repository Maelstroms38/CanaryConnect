//
//  DetailViewController.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "DetailViewController.h"
#import "CoreDataManager.h"
#import "Device+Retrieval.h"

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
    [[CoreDataController sharedCache] getReadingsForDevice: self.deviceId completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        if (success) {
            CoreDataManager *coreDataManager = [CoreDataManager defaultManager];
            Device *device = [Device deviceWithID:self.deviceId managedObjectContext:coreDataManager.managedObjectContext createIfNeeded:false];
            self.device = device;
            [self setupTableHeader];
        }
    }];
}

- (void)setupTableHeader {
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.20)];
    self.tableView.tableHeaderView = tableHeader;
    UILabel *deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableHeader.frame.size.width, 0)];
    deviceLabel.textAlignment = NSTextAlignmentCenter;
    deviceLabel.textColor = [UIColor blackColor];
    deviceLabel.text = self.device.name;
    [deviceLabel sizeToFit];
    [self.tableView.tableHeaderView addSubview:deviceLabel];
    // activate constraints
    deviceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[deviceLabel.centerXAnchor constraintEqualToAnchor:tableHeader.centerXAnchor] setActive:YES];
    [[deviceLabel.centerYAnchor constraintEqualToAnchor:tableHeader.centerYAnchor] setActive:YES];
    
    // Get Max, Min and Average temps
    NSNumber *maxTemp = 0;
    NSNumber *minTemp = [[NSNumber alloc] initWithInt:999];
    NSNumber *averageTemp = 0;
    NSNumber *tempsCount = 0;
    for (int i = 0; i <self.device.readings.count; i++) {
        Reading *reading = [[self.device.readings allObjects] objectAtIndex:i];
        NSString *type = reading.type;
        NSNumber *value = reading.value;
        if ([type isEqual: @"temperature"]) {
            maxTemp = MAX(value, maxTemp);
            minTemp = MIN(value, minTemp);
            tempsCount = @([tempsCount integerValue] + 1);
            averageTemp = @([averageTemp integerValue] + [value integerValue]);
        } else if ([type isEqual: @"airquality"]) {
            
        } else if ([type isEqual: @"humidity"]) {
            
        }
        if (i == self.device.readings.count-1) {
            averageTemp = @([averageTemp integerValue] / [tempsCount integerValue]);
        }
        
    }
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableHeader.frame.size.width, 0)];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor blackColor];
    tempLabel.text = [[NSString alloc] initWithFormat:@"Average: %@", averageTemp];
    [tempLabel sizeToFit];
    
    UILabel *highLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableHeader.frame.size.width, 0)];
    highLabel.textAlignment = NSTextAlignmentCenter;
    highLabel.textColor = [UIColor blackColor];
    highLabel.text = [[NSString alloc] initWithFormat:@"High: %@", maxTemp];
    [highLabel sizeToFit];
    
    UILabel *lowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableHeader.frame.size.width, 0)];
    lowLabel.textAlignment = NSTextAlignmentCenter;
    lowLabel.textColor = [UIColor blackColor];
    lowLabel.text = [[NSString alloc] initWithFormat:@"Low: %@", minTemp];
    [lowLabel sizeToFit];
    
    if ([lowLabel.text isEqualToString: @"Low: 999"]) {
        lowLabel.hidden = true;
    }
    
    UIStackView *stackView = [[UIStackView alloc] init];
    [stackView addArrangedSubview:highLabel];
    [stackView addArrangedSubview:tempLabel];
    [stackView addArrangedSubview:lowLabel];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 30;
    [tableHeader addSubview:stackView];
    // Layout for Stack View
    [[stackView.centerXAnchor constraintEqualToAnchor:tableHeader.centerXAnchor] setActive:true];
    [[stackView.bottomAnchor constraintEqualToAnchor:tableHeader.bottomAnchor] setActive:true];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
    cell.textLabel.text = reading.type.capitalizedString;
    UILabel *tempLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 20)];
    tempLabel.text = [[NSString alloc] initWithFormat:@"%@", reading.value];
    tempLabel.textAlignment = NSTextAlignmentRight;
    cell.accessoryView = tempLabel;
    return cell;
}
@end
