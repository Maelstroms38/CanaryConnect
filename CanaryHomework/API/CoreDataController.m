//
//  CoreDataController.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "CoreDataController.h"
#import "CoreDataManager.h"
#import "APIClient.h"
#import "Device+ParserLogic.h"
#import "Reading+ParserLogic.h"
#import "Device+Retrieval.h"


@interface CoreDataController ()

@property (strong, nonatomic, readonly) NSManagedObjectContext *privateObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) dispatch_queue_t reloadQueue;

@end

@implementation CoreDataController

- (instancetype)init
{
    if ( self = [super init] )
    {
        CoreDataManager *coreDataManager = [CoreDataManager defaultManager];
        _managedObjectContext = coreDataManager.managedObjectContext;
        _reloadQueue = dispatch_queue_create("is.canary.CacheController.reloadQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(_reloadQueue, ^
        {
            _privateObjectContext = [coreDataManager createContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
        });
        
    }
    return self;
}

#pragma mark - Public Methods

+ (CoreDataController *)sharedCache
{
    static CoreDataController *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedCache = [self new];
    });
    return sharedCache;
}

- (void)getAllDevices:(CoreDataControllerCompletionBlock)completionBlock {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.reloadQueue, ^ {
        [[APIClient sharedClient] getDeviceWithCompletionBlock:^(BOOL success, id responseObject) {
            dispatch_async(weakSelf.reloadQueue, ^ {
                if (success) {
                    [weakSelf insertObjectsWithDictionaries:responseObject withCreationBlock:^(NSDictionary *dictionary, NSManagedObjectContext *insertContext) {
                        return [Device deviceFromDictionary:dictionary managedObjectContext:insertContext];
                    }
                    completionBlock:^(NSArray *objects, NSError *error) {
                        if (completionBlock != nil){
                            completionBlock(YES, YES, objects);
                        }
                    }];
                }
                else if ( completionBlock != nil ) {
                    NSArray *errorsArray = responseObject;
                    completionBlock(YES, NO, errorsArray);
                }
            });
        }];
    });
}

-(void)getReadingsForDevice:(NSString *)deviceID completionBlock:(CoreDataControllerCompletionBlock)completionBlock {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.reloadQueue, ^ {
        [[APIClient sharedClient] getDevice:deviceID readingsWithCompletionBlock:^(BOOL success, id responseObject) {
            if (success) {
                Device *device = [Device deviceWithID:deviceID managedObjectContext:self.privateObjectContext createIfNeeded:YES];
                [device removeReadings:device.readings];
                [weakSelf insertObjectsWithDictionaries:responseObject withCreationBlock:^NSManagedObject *(NSDictionary *dictionary, NSManagedObjectContext *insertContext) {
                    return [Reading readingFromDictionary:dictionary forDevice:deviceID managedObjectContext:insertContext];

                } completionBlock:^(NSArray *objects, NSError *error) {
                    
                }];
            }
        }];
    });
}
- (void)insertObjectsWithDictionaries:(NSArray *)objectDictionaries withCreationBlock:(NSManagedObject *(^)(NSDictionary *, NSManagedObjectContext *))creationBlock completionBlock:(void(^)(NSArray *, NSError *))completionBlock {

    NSManagedObjectContext *insertContext = self.privateObjectContext;
    NSMutableArray *insertedObjects = [NSMutableArray new];
    
    __block NSError *error;
    [insertContext performBlockAndWait:^ {
        for ( NSDictionary *objectDictionary in objectDictionaries )
        {
            NSManagedObject *managedObject = creationBlock(objectDictionary, insertContext);
            if ( managedObject != nil )
            {
                [insertedObjects addObject:managedObject];
            }
        }
        [insertContext save:&error];
    }];
    
    if ( error != nil )
    {
    NSLog(@"Error on saving: %@", error);
    }
    
    if ( completionBlock != nil )
    {
        completionBlock(insertedObjects, error);
    }
}

@end
