//
//  AppDelegate.h
//  CanaryHomework
//
//  Created by Michael Stromer on 10/18/19.
//  Copyright © 2019 Michael Stromer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

