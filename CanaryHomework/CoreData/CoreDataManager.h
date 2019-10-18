//
//  CoreDataManager.h
//  Canary
//
//  Created by Canary Secure on 4/17/15.
//  Copyright (c) 2015 Michael Klein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (CoreDataManager *)defaultManager;
+ (CoreDataManager *)managerForModelName:(NSString *)modelName;
+ (CoreDataManager *)managerForModelName:(NSString *)modelName databaseName:(NSString *)databaseName;

//Note: If creating context with concurrency type NSConfinementConcurrencyType, updates from other contexts will not be performed automatically.
- (NSManagedObjectContext *)createContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

@end
