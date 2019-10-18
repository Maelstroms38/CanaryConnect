//
//  Location+Retrieval.m
//  Canary
//
//  Created by Andrew Whitcomb on 5/13/15.
//  Copyright (c) 2015 Michael Klein. All rights reserved.
//

#import "Device+Retrieval.h"
#import "Device+CoreDataProperties.h"

@implementation Device (Retrieval)

#pragma mark - Public Methods

+ (Device *)deviceWithID:(NSString *)deviceID managedObjectContext:(NSManagedObjectContext *)managedObjectContext createIfNeeded:(BOOL) createIfNeeded {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Device" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID == %@", deviceID];
    [fetchRequest setPredicate:predicate];
    
    Device *device = [[managedObjectContext executeFetchRequest:fetchRequest error:NULL] firstObject];
    if (device == nil && createIfNeeded) {
        device = [[Device alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        device.deviceID = deviceID;
    }
    return device;
}


@end
