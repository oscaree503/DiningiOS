//
//  ProfileTableViewCell.m
//  Dining
//
//  Created by Polaris on 12/27/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_lblProfileItem setTextColor:RGBA(200, 200, 200, 1)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
