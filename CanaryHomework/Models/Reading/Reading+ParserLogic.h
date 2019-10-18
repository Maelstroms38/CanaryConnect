//
//  Reading+ParserLogic.h
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/25/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "Reading+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Reading (ParserLogic)

+ (Reading *)readingFromDictionary:(NSDictionary *)dictionary forDevice:(NSString *)deviceID managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

NS_ASSUME_NONNULL_END
