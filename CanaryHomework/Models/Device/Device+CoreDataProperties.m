//
//  Device+CoreDataProperties.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/19/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//
//

#import "Device+CoreDataProperties.h"

@implementation Device (CoreDataProperties)

+ (NSFetchRequest<Device *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Device"];
}

@dynamic name;
@dynamic createAt;
@dynamic updateAt;
@dynamic deviceID;
@dynamic readings;

@end
