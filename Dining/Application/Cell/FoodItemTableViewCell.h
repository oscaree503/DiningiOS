//
//  FoodItemTableViewCell.h
//  Dining
//
//  Created by Polaris on 12/15/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblFoodName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imgFood1;
@property (strong, nonatomic) IBOutlet UIImageView *imgFood2;
@property (strong, nonatomic) IBOutlet UIImageView *imgFood3;

@end
