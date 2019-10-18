//
//  DateFormatter.h
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/25/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateFormatter : NSObject

+ (DateFormatter *) sharedFormatter;
-(NSDate *) dateFromAPIString:(NSString *)dateString;
-(NSString *) stringFromDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
