//
//  FoodDetailTableViewCell.h
//  Dining
//
//  Created by Polaris on 12/22/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgSellerPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblSellerName;
@property (strong, nonatomic) IBOutlet UILabel *lblSellerRange;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodName;
@property (strong, nonatomic) IBOutlet UILabel *lblCity;

@property (strong, nonatomic) IBOutlet UIImageView *imgFooddetail;

@property (strong, nonatomic) IBOutlet UIImageView *imgLike;
@property (strong, nonatomic) IBOutlet UILabel *lblLikeCount;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;

@property (strong, nonatomic) IBOutlet UIImageView *imgComment;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;

@property (strong, nonatomic) IBOutlet UIImageView *imgShare;
@property (strong, nonatomic) IBOutlet UILabel *lblShare;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@end
