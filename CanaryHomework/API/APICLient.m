//
//  APICLient.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "APIClient.h"
#import <Foundation/Foundation.h>
#import "Keys.h"
#import "AFNetworking.h"
@interface APIClient ()

@property (strong, nonatomic) AFHTTPSessionManager *defaultSessionManager;

@end

@implementation APIClient


- (id)init
{
    if ( self = [super init] )
    {
        [self setupDefaultSessionManager];
    }
    return self;
}

- (void)setupDefaultSessionManager
{
    NSURL *baseURL = [NSURL URLWithString:SERVER_URL];
    self.defaultSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    [self.defaultSessionManager.operationQueue setMaxConcurrentOperationCount:4];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [self.defaultSessionManager setResponseSerializer:responseSerializer];

    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:4.0f];
    [requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [self.defaultSessionManager setRequestSerializer:requestSerializer];
}

#pragma mark - Public Methods

+ (APIClient *)sharedClient
{
    static APIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedClient = [self new];
                  });
    
    return sharedClient;
}

#pragma mark - Default Completion Blocks

- (APIClientOperationSuccessBlock)defaultSuccessResponseWithCompletionBlock:(APIClientCompletionBlock)completionBlock
{
    return [[self class] defaultSuccessResponseWithCompletionBlock:completionBlock];
}

+ (APIClientOperationSuccessBlock)defaultSuccessResponseWithCompletionBlock:(APIClientCompletionBlock)completionBlock
{
    return ^(NSURLSessionDataTask *task, id responseObject)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        void(^responseCompletionBlock)(NSHTTPURLResponse *, id) = [self defaultURLResponseSuccessBlockWithCompletionBlock:completionBlock];
        responseCompletionBlock(httpResponse, responseObject);
    };
}

- (void(^)(NSHTTPURLResponse *, id))defaultURLResponseSuccessBlockWithCompletionBlock:(APIClientCompletionBlock)completionBlock {
    return [[self class] defaultURLResponseSuccessBlockWithCompletionBlock:completionBlock];
}

+ (void(^)(NSHTTPURLResponse *, id))defaultURLResponseSuccessBlockWithCompletionBlock:(APIClientCompletionBlock)completionBlock {
    return ^(NSHTTPURLResponse *response, id responseObject) {
        completionBlock(YES, responseObject);
    };
    
}

- (APIClientOperationFailureBlock)defaultFailureResponseWithCompletionBlock:(APIClientCompletionBlock)completionBlock {
    return [[self class] defaultFailureResponseWithCompletionBlock:completionBlock];
}

+ (APIClientOperationFailureBlock)defaultFailureResponseWithCompletionBlock:(APIClientCompletionBlock)completionBlock {
    return ^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", [task.response.URL absoluteString]);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        void(^responseCompletionBlock)(NSHTTPURLResponse *, NSError *) = [self defaultURLResponseFailureBlockWithRequest:task.originalRequest completionBlock:completionBlock];
        responseCompletionBlock(httpResponse, error);
    };
}

- (void(^)(NSHTTPURLResponse *, NSError *))defaultURLResponseFailureBlockWithRequest:(NSURLRequest *)request completionBlock:(APIClientCompletionBlock)completionBlock {
    return [[self class] defaultURLResponseFailureBlockWithRequest:request completionBlock:completionBlock];
}

+ (void(^)(NSHTTPURLResponse *, NSError *))defaultURLResponseFailureBlockWithRequest:(NSURLRequest *)request completionBlock:(APIClientCompletionBlock)completionBlock {
    return ^(NSHTTPURLResponse *response, NSError *error) {
        if (completionBlock != nil ){
            completionBlock(NO, response);
        }
        
    };
}

- (void)performOperationWithURI:(NSString *)URI completionBlock:(APIClientCompletionBlock)completionBlock
{
    APIClientOperationSuccessBlock successBlock = [self defaultSuccessResponseWithCompletionBlock:completionBlock];
    APIClientOperationFailureBlock failureBlock = [self defaultFailureResponseWithCompletionBlock:completionBlock];
    [self performOperationTypeWithURI:URI successBlock:successBlock failureBlock:failureBlock];
}

- (void)performOperationTypeWithURI:(NSString *)URI successBlock:(APIClientOperationSuccessBlock)successBlock failureBlock:(APIClientOperationFailureBlock)failureBlock
{
    [self.defaultSessionManager GET:URI parameters:nil progress:nil success:successBlock failure:failureBlock];
}


-(void) getDeviceWithCompletionBlock:(APIClientCompletionBlock)completionBlock {
    NSString * uri = @"/devices";
    [self performOperationWithURI:uri completionBlock:completionBlock];

}

-(void)getDevice:(NSString *) deviceId readingsWithCompletionBlock:(APIClientCompletionBlock)completionBlock {
    NSString * uri = [NSString stringWithFormat:@"/devices/%@/readings", deviceId];
    [self performOperationWithURI:uri completionBlock:completionBlock];
}


@end
