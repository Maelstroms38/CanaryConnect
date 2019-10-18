//
//  ApiClient.h
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^APIClientCompletionBlock)(BOOL success, id responseObject);
typedef void(^APIClientOperationSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^APIClientOperationFailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface APIClient : NSObject

+(APIClient *)sharedClient;

#pragma mark - Devices
-(void)getDeviceWithCompletionBlock:(APIClientCompletionBlock)completionBlock;

-(void)getDevice:(NSString *) deviceId readingsWithCompletionBlock:(APIClientCompletionBlock)completionBlock;

@end
