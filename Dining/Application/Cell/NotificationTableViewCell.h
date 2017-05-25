//
//  NotificationTableViewCell.h
//  Dining
//
//  Created by Polaris on 12/27/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblPastTime;
@property (strong, nonatomic) IBOutlet UILabel *lblNotificationContent;

@end
