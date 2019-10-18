//
//  Reading+ParserLogic.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/25/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "Reading+ParserLogic.h"
#import "Device+Retrieval.h"
#import "DateFormatter.h"

@implementation Reading (ParserLogic)

+ (Reading *)readingFromDictionary:(NSDictionary *)dictionary forDevice:(nonnull NSString *)deviceID managedObjectContext:(nonnull NSManagedObjectContext *)managedObjectContext
{
    Device *device = [Device deviceWithID:deviceID managedObjectContext:managedObjectContext createIfNeeded:false];
    
    if (device == nil) {
        return nil;
    }
    
    Reading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"Reading" inManagedObjectContext:managedObjectContext];
    reading.createdAt = [[DateFormatter sharedFormatter] dateFromAPIString:dictionary[@"createdAt"]];
    reading.updatedAt =  [[DateFormatter sharedFormatter] dateFromAPIString:dictionary[@"updatedAt"]];;
    reading.value =  dictionary[@"value"];
    reading.type = dictionary[@"type"];
    reading.device = device;
    return reading;
}
@end
