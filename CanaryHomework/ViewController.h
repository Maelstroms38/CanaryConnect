//
//  ViewController.h
//  CanaryHomework
//
//  Created by Michael Stromer on 10/18/19.
//  Copyright © 2019 Michael Stromer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property(nonatomic, retain) NSManagedObjectContext *context;

@end

