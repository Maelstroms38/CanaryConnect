//
//  DeviceTableViewCell.h
//  CanaryHomework
//
//  Created by Michael Stromer on 10/18/19.
//  Copyright © 2019 Michael Stromer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@end

NS_ASSUME_NONNULL_END
