//
//  Reading+CoreDataProperties.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/19/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//
//

#import "Reading+CoreDataProperties.h"

@implementation Reading (CoreDataProperties)

+ (NSFetchRequest<Reading *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
}

@dynamic type;
@dynamic value;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic device;

@end
