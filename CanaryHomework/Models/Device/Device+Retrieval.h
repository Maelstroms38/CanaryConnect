//
//  Location+Retrieval.h
//  Canary
//
//  Created by Andrew Whitcomb on 5/13/15.
//  Copyright (c) 2015 Michael Klein. All rights reserved.
//

#import "Device+CoreDataClass.h"

@interface Device (Retrieval)

+ (Device *)deviceWithID:(NSString *)deviceID managedObjectContext:(NSManagedObjectContext *)managedObjectContext createIfNeeded:(BOOL)createIfNeeded;

@end
