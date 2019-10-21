//
//  CanaryHomeworkTests.m
//  CanaryHomeworkTests
//
//  Created by Michael Stromer on 10/21/19.
//  Copyright © 2019 Michael Stromer. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CanaryHomeworkTests : XCTestCase

@end

@implementation CanaryHomeworkTests

- (NSDictionary *)JSONFromFile:(NSString*)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error){
        NSLog(@"Something went wrong! %@", error.localizedDescription);
    }
    return json;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDeviceList {
    NSDictionary *devices = [self JSONFromFile:@"devices"];
    for (NSDictionary *device in devices) {
        NSString *name = [device objectForKey:@"name"];
        if ([name isEqualToString:@"Malory's Bedroom"]) {
            NSString *deviceId = device[@"id"];
            XCTAssertEqualObjects(deviceId, @"Syg4xfke7");
            
        } else if ([name isEqualToString:@"Figgis Agency"]) {
            NSString *deviceId = device[@"id"];
            XCTAssertEqualObjects(deviceId, @"ByyLef1em");
            
        } else if ([name isEqualToString:@"Front Desk"]) {
            NSString *deviceId = device[@"id"];
            XCTAssertEqualObjects(deviceId, @"rkfOgMJe7");
            
        } else if ([name isEqualToString:@"Canary Office"]) {
            NSString *deviceId = device[@"id"];
            XCTAssertEqualObjects(deviceId, @"Sk1txZvxX");
            
        } else if ([name isEqualToString:@"Eric's \\0ffice"]) {
            NSString *deviceId = device[@"id"];
            XCTAssertEqualObjects(deviceId, @"HyqVV8p8B");
        }
    }
}

- (void)testDeviceDetail {
    NSDictionary *device = [self JSONFromFile:@"deviceDetail"];
    NSString *name = [device objectForKey:@"name"];
    if ([name isEqualToString:@"Malory's Bedroom"]) {
        NSString *deviceId = device[@"id"];
        XCTAssertEqualObjects(deviceId, @"Syg4xfke7");
    }
}

@end
