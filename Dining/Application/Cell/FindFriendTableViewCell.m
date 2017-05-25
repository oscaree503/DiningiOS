//
//  FindFriendTableViewCell.m
//  Dining
//
//  Created by Polaris on 12/23/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "FindFriendTableViewCell.h"

@implementation FindFriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [commonUtils cropCircleImage:_imgFriends];
    [commonUtils setRoundedRectBorderButton:_btnFollow withBorderWidth:2 withBorderColor:RGBA(254, 137, 92, 1) withBorderRadius:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
