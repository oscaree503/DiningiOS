//
//  FoodTableViewCell.h
//  Dining
//
//  Created by Polaris on 12/13/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgFood;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodName;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodLocation;
@property (strong, nonatomic) IBOutlet UIImageView *imgOwnerPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblOwnerName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblnLikes;

@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;

@property (strong, nonatomic) IBOutlet UIImageView *imgLike;
@property (strong, nonatomic) IBOutlet UIImageView *imgShare;

@property (nonatomic) int isLike;
@property (nonatomic) int isShare;

@end
