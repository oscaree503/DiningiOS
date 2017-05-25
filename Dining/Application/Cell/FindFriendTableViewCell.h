//
//  FindFriendTableViewCell.h
//  Dining
//
//  Created by Polaris on 12/23/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindFriendTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgFriends;
@property (strong, nonatomic) IBOutlet UILabel *lblFriendName;
@property (strong, nonatomic) IBOutlet UILabel *lblFollowCount;
@property (strong, nonatomic) IBOutlet UIButton *btnFollow;
@property (nonatomic,assign) int nFollow;

@end
