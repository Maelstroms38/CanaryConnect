//
//  DetailViewController.h
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device+CoreDataProperties.h"
#import "Reading+CoreDataProperties.h"
#import "CoreDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) Device *device;
@property (nonatomic, weak) CoreDataController *controller;

@end

NS_ASSUME_NONNULL_END
