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
@property(nonatomic, retain) UISegmentedControl *segmentControl;

@property(nonatomic, weak) NSNumber *max;
@property(nonatomic, weak) NSNumber *min;
@property(nonatomic, weak) NSNumber *average;

@property(nonatomic, weak) NSNumber *maxTemp;
@property(nonatomic, weak) NSNumber *minTemp;
@property(nonatomic, weak) NSNumber *aveTemp;

@property(nonatomic, weak) NSNumber *maxAir;
@property(nonatomic, weak) NSNumber *minAir;
@property(nonatomic, weak) NSNumber *aveAir;

@property(nonatomic, weak) NSNumber *maxHum;
@property(nonatomic, weak) NSNumber *minHum;
@property(nonatomic, weak) NSNumber *aveHum;

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
        if (completed) {
            CoreDataManager *coreDataManager = [CoreDataManager defaultManager];
            Device *device = [Device deviceWithID:self.deviceId managedObjectContext:coreDataManager.managedObjectContext createIfNeeded:false];
            self.device = device;
            [self setupTableHeader];
            [self calculateTemps:^{
                [self segmentSelected:nil];
            }];
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
    
    NSArray *items = @[@"Temperature", @"Humidity", @"Air Quality"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    [segment setWidth:tableHeader.frame.size.width / 3 forSegmentAtIndex:0];
    [segment setWidth:tableHeader.frame.size.width / 3 forSegmentAtIndex:1];
    [segment setWidth:tableHeader.frame.size.width / 3 forSegmentAtIndex:2];
    [segment addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    [tableHeader addSubview:segment];
    segment.translatesAutoresizingMaskIntoConstraints = false;
    [[segment.bottomAnchor constraintEqualToAnchor:tableHeader.bottomAnchor] setActive:true];
    [[segment.centerXAnchor constraintEqualToAnchor:tableHeader.centerXAnchor] setActive:YES];
    self.segmentControl = segment;
}

- (void)calculateTemps:(void (^)(void))completionBlock {
    // Get Max, Min and Average Temp
    NSNumber *maxTemp = 0;
    NSNumber *minTemp = [NSNumber numberWithInt:INFINITY];
    NSNumber *aveTemp = 0;
    
    // Get Max, Min and Average Air Quality
    NSNumber *maxAir = 0;
    NSNumber *minAir = [NSNumber numberWithInt:INFINITY];
    NSNumber *aveAir = 0;
    
    // Get Max, Min and Average Air Humidity
    NSNumber *maxHum = 0;
    NSNumber *minHum = [NSNumber numberWithInt:INFINITY];
    NSNumber *aveHum = 0;
    
    NSArray *items = @[@"temperature", @"airquality", @"humidity"];
    
    for (Reading *reading in self.device.readings) {
        NSString *type = reading.type;
        NSNumber *value = reading.value;
        int item = (int)[items indexOfObject:type];
        switch (item) {
            case 0:
                maxTemp = MAX(value, maxTemp);
                minTemp = MIN(value, minTemp);
                aveTemp = @(([maxTemp integerValue] + [minTemp integerValue]) / 2);
                break;
            case 1:
                maxAir = MAX(value, maxAir);
                minAir = MIN(value, minAir);
                aveAir = @(([maxAir integerValue] + [minAir integerValue]) / 2);
                break;
            case 2:
                maxHum = MAX(value, maxHum);
                minHum = MIN(value, minHum);
                aveHum = @(([maxHum integerValue] + [minHum integerValue]) / 2);
                break;
            default:
                break;
        }
    }
    
    self.maxTemp = maxTemp;
    self.minTemp = minTemp;
    self.aveTemp = aveTemp;
    
    self.max = maxTemp;
    self.min = minTemp;
    self.average = aveTemp;
    
    self.maxAir = maxAir;
    self.minAir = minAir;
    self.aveAir = aveAir;
    
    self.maxHum = maxHum;
    self.minHum = minHum;
    self.aveHum = aveHum;
    
    if (completionBlock != nil) {
        completionBlock();
    }
}

- (void)segmentSelected:(id)sender {
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            self.max = self.maxTemp;
            self.min = self.minTemp;
            self.average = self.aveTemp;
            break;
        case 1:
            self.max = self.maxHum;
            self.min = self.minHum;
            self.average = self.aveHum;
            break;
        case 2:
            self.max = self.maxAir;
            self.min = self.minAir;
            self.average = self.aveAir;
            break;
        default:
            break;
    }
    [self.tableView beginUpdates];
    NSArray<NSIndexPath *> *indices = @[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
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
    return 3;
}

#pragma mark UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell from the object
    UILabel *tempLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 20)];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Maximum";
            tempLabel.text = [[NSString alloc] initWithFormat:@"%@", self.max];
            tempLabel.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = tempLabel;
            return cell;
            
        case 1:
            cell.textLabel.text = @"Minimum";
            tempLabel.text = [[NSString alloc] initWithFormat:@"%@", self.min];
            tempLabel.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = tempLabel;
            return cell;
            
        case 2:
            cell.textLabel.text = @"Average";
            tempLabel.text = [[NSString alloc] initWithFormat:@"%@", self.average];
            tempLabel.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = tempLabel;
            return cell;
            
        default:
            break;
    }
    return cell;
}
@end
