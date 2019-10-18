//
//  CoreDataController.h
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CoreDataControllerCompletionBlock)(BOOL completed, BOOL success, NSArray *objects);

@interface CoreDataController : NSObject

#pragma mark - Shared Cache
+ (CoreDataController *)sharedCache;

#pragma mark - Device
- (void)getAllDevices:(CoreDataControllerCompletionBlock)completionBlock;


#pragma mark - Reading
-(void)getReadingsForDevice:(NSString *)deviceID completionBlock:(CoreDataControllerCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
