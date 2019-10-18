//
//  DateFormatter.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/25/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "DateFormatter.h"

@interface DateFormatter ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation DateFormatter

+ (DateFormatter *)sharedFormatter {
    static DateFormatter *sharedFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedFormatter = [self new];
    });
    return sharedFormatter;
}

-(instancetype) init    {
    self = [super init];

    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MMM d, h:mm a";
    }
    return self;
}


- (NSDate *)dateFromAPIString:(NSString *)dateString {
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString *)stringFromDate:(NSDate *)date {
    return [self.dateFormatter stringFromDate:date];
}
@end
