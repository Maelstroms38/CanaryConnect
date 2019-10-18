//
//  Location+ParserLogic.m
//  Canary
//
//  Created by Andrew Whitcomb on 5/13/15.
//  Copyright (c) 2015 Michael Klein. All rights reserved.
//

#import "Device+ParserLogic.h"
#import "Device+CoreDataProperties.h"
#import "Device+Retrieval.h"
#import "DateFormatter.h"

@implementation Device (ParserLogic)

#pragma mark - Public Methods

+ (Device *)deviceFromDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Device *device = [self deviceWithID:dictionary[@"id"] managedObjectContext:managedObjectContext createIfNeeded:YES];
    device.name = dictionary[@"name"];
    device.createAt = [[DateFormatter sharedFormatter] dateFromAPIString:dictionary[@"createdAt"]];
    device.updateAt = [[DateFormatter sharedFormatter] dateFromAPIString:dictionary[@"updatedAt"]];
    return device;
}

@end
