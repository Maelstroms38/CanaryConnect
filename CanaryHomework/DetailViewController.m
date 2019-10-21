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
@property(nonatomic, retain) UILabel *deviceNameLabel;

@property(nonatomic, weak) NSNumber *max;
@property(nonatomic, weak) NSNumber *min;
@property(nonatomic, weak) NSNumber *average;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"About Device";
    self.safeArea = self.view.layoutMarginsGuide;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    [self setupTableHeader];
    [self setupDeviceLabel];
    // add readings to device
    [self fetchDeviceReadings];
}
- (void)fetchDeviceReadings {
    [[CoreDataController sharedCache] getReadingsForDevice: self.deviceId completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        if (completed) {
            CoreDataManager *coreDataManager = [CoreDataManager defaultManager];
            Device *device = [Device deviceWithID:self.deviceId managedObjectContext:coreDataManager.managedObjectContext createIfNeeded:false];
            self.deviceNameLabel.text = device.name;
            [self segmentSelected:nil];
        }
    }];
}

- (void)setupDeviceLabel {
    UIView *tableHeader = self.tableView.tableHeaderView;
    UILabel *deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableHeader.frame.size.width, 0)];
    self.deviceNameLabel = deviceLabel;
    deviceLabel.textAlignment = NSTextAlignmentCenter;
    deviceLabel.textColor = [UIColor blackColor];
    [deviceLabel sizeToFit];
    [tableHeader addSubview:deviceLabel];
    deviceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[deviceLabel.centerXAnchor constraintEqualToAnchor:tableHeader.centerXAnchor] setActive:YES];
    [[deviceLabel.centerYAnchor constraintEqualToAnchor:tableHeader.centerYAnchor] setActive:YES];
}
- (void)setupTableHeader {
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.20)];
    self.tableView.tableHeaderView = tableHeader;
    // activate constraints
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

- (void)calculateTemps:(NSString*)type completion:(void (^)(void))completionBlock {
    CoreDataManager *coreDataManager = [CoreDataManager defaultManager];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reading" inManagedObjectContext:coreDataManager.managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"device.deviceID == %@ && type == %@", self.deviceId, type];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray<Reading *> *readings = [coreDataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Get Average, Maximum and Minimum values.
    self.average = [readings valueForKeyPath:@"@avg.value"];
    self.max = [readings valueForKeyPath:@"@max.value"];
    self.min = [readings valueForKeyPath:@"@min.value"];
    if (completionBlock != nil) {
        completionBlock();
    }
}

- (void)segmentSelected:(id)sender {
        NSArray *items = @[@"temperature", @"airquality", @"humidity"];
        NSString *type = [items objectAtIndex:self.segmentControl.selectedSegmentIndex];
        [self calculateTemps:type completion:^{
            [self.tableView beginUpdates];
            NSArray<NSIndexPath *> *indices = @[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0]];
            [self.tableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
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
    return 3;
}

#pragma mark UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell from the object
    UILabel *tempLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 20)];
    NSArray *items = @[@"*F", @"%", @"%"];
    NSString *unit = [items objectAtIndex:self.segmentControl.selectedSegmentIndex];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Maximum";
            tempLabel.text = [[[[NSString alloc] initWithFormat:@"%@", self.max] substringToIndex:2] stringByAppendingString:unit];
            tempLabel.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = tempLabel;
            return cell;
            
        case 1:
            cell.textLabel.text = @"Minimum";
            tempLabel.text = [[[[NSString alloc] initWithFormat:@"%@", self.min] substringToIndex:2] stringByAppendingString:unit];
            tempLabel.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = tempLabel;
            return cell;
            
        case 2:
            cell.textLabel.text = @"Average";
            tempLabel.text = [[[[NSString alloc] initWithFormat:@"%@", self.average] substringToIndex:2] stringByAppendingString:unit];
            tempLabel.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = tempLabel;
            return cell;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
@end
