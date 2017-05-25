//
//  FoodDetailTableViewCell.m
//  Dining
//
//  Created by Polaris on 12/22/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "FoodDetailTableViewCell.h"

@implementation FoodDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [commonUtils cropCircleImage:_imgSellerPhoto];
//    [commonUtils setCircleBorderImage:_imgSellerPhoto withBorderWidth:1 withBorderColor:RGBA(255, 255, 255, 1)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
