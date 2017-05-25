//
//  FoodTableViewCell.m
//  Dining
//
//  Created by Polaris on 12/13/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "FoodTableViewCell.h"

@implementation FoodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [commonUtils cropCircleImage:_imgOwnerPhoto];
    
    _isLike = 0;
    _isShare = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
