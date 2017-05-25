//
//  NotificationTableViewCell.m
//  Dining
//
//  Created by Polaris on 12/27/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [commonUtils cropCircleImage:_imgPhoto];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
