 //
//  CoreDataManager.m
//  Canary
//
//  Created by Canary Secure on 4/17/15.
//  Copyright (c) 2015 Michael Klein. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSPointerArray *contextArray;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) dispatch_queue_t contextSavedQueue;
@property (assign, nonatomic) dispatch_once_t queueCreationOnceToken;

@end

@implementation CoreDataManager

#pragma mark - Overrides

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithModelName:(NSString *)modelName databaseName:(NSString *)databaseName
{
    if ( self = [super init] )
    {
        _modelName = modelName;
        _databaseName = databaseName;
        _contextArray = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

#pragma mark - Public Methods

+ (CoreDataManager *)defaultManager
{
    static CoreDataManager *defaultManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        defaultManager = [self managerForModelName:@"CanaryHomework"];
    });
    return defaultManager;
}

+ (CoreDataManager *)managerForModelName:(NSString *)modelName
{
    return [self managerForModelName:modelName databaseName:modelName];
}

+ (CoreDataManager *)managerForModelName:(NSString *)modelName databaseName:(NSString *)databaseName
{
    static NSMutableDictionary *managerDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        managerDictionary = [NSMutableDictionary new];
    });
    CoreDataManager *coreDataManager = [managerDictionary objectForKey:databaseName];
    if ( coreDataManager == nil )
    {
        coreDataManager = [[CoreDataManager alloc] initWithModelName:modelName databaseName:databaseName];
        [managerDictionary setObject:coreDataManager forKey:databaseName];
    }
    return coreDataManager;
}

- (NSManagedObjectContext *)createContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    [newContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [newContext setRetainsRegisteredObjects:YES];
    [newContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    [self addObserverForContext:newContext];
    [self.contextArray addPointer:(__bridge void *)newContext];
    return newContext;
}

#pragma mark - Property Overrides

- (NSPointerArray *)contextArray
{
    [_contextArray compact];
    return _contextArray;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if ( _managedObjectContext != nil )
    {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [self createContextWithConcurrencyType:NSMainQueueConcurrencyType];
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if ( _managedObjectModel != nil )
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if ( _persistentStoreCoordinator != nil )
    {
        return _persistentStoreCoordinator;
    }
    
    BOOL shouldRestart = NO;

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES
                              };
    
    NSError *error = nil;
    NSString *persistentStoreFileName = [NSString stringWithFormat:@"%@.sqlite", self.databaseName];
    
    NSURL *newStoreURL;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:persistentStoreFileName];
    if ( ![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error] )
    {
        shouldRestart = YES;
    }
    
    if (shouldRestart) {
        //Delete the database completely
        [[NSFileManager defaultManager] removeItemAtURL:newStoreURL error:nil];
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        //Recreate the persistentStoreCoordinator from scratch
        return [self persistentStoreCoordinator];
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Private Methods

- (void)addObserverForContext:(NSManagedObjectContext *)context
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:context];
}

- (void)addObserverForAllContexts
{
    for ( NSManagedObjectContext *context in self.contextArray )
    {
        [self addObserverForContext:context];
    }
}

- (void)removeObserverForContext:(NSManagedObjectContext *)context
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:context];
}

- (void)removeObserverForAllContexts
{
    for ( NSManagedObjectContext *context in self.contextArray )
    {
        [self removeObserverForContext:context];
    }
}

#pragma mark - Context Did Save Notification

- (void)contextDidSave:(NSNotification *)notification
{
    dispatch_once(&_queueCreationOnceToken, ^
    {
        NSString *queueName = [NSString stringWithFormat:@"is.Canary.CoreDataManager.%@.contextSavedQueue", self.databaseName];
        self.contextSavedQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_sync(self.contextSavedQueue, ^
    {
        NSManagedObjectContext *notificationContext = [notification object];
        NSPointerArray *contextArrayCopy = [self.contextArray copy];
        for ( NSManagedObjectContext *context in contextArrayCopy )
        {
            if ( ![context isEqual:notificationContext] )
            {
                [context performBlock:^
                {
                    [self removeObserverForContext:context];
                    [context mergeChangesFromContextDidSaveNotification:notification];
                    [self addObserverForContext:context];
                }];
            }
        }
    });
}

#pragma mark - Private Methods

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
