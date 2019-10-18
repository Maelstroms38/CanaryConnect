//
//  Reading+CoreDataProperties.h
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/19/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//
//

#import "Reading+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Reading (CoreDataProperties)

+ (NSFetchRequest<Reading *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *value;
@property (nullable, nonatomic, copy) NSDate *createdAt;
@property (nullable, nonatomic, copy) NSDate *updatedAt;
@property (nullable, nonatomic, retain) Device *device;

@end

NS_ASSUME_NONNULL_END
