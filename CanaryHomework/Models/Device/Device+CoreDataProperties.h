//
//  Device+CoreDataProperties.h
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/19/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//
//

#import "Device+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Device (CoreDataProperties)

+ (NSFetchRequest<Device *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *createAt;
@property (nullable, nonatomic, copy) NSDate *updateAt;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nullable, nonatomic, retain) NSSet<Reading *> *readings;

@end

@interface Device (CoreDataGeneratedAccessors)

- (void)addReadingsObject:(Reading *)value;
- (void)removeReadingsObject:(Reading *)value;
- (void)addReadings:(NSSet<Reading *> *)values;
- (void)removeReadings:(NSSet<Reading *> *)values;

@end

NS_ASSUME_NONNULL_END
