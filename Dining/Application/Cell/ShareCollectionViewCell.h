//
//  ShareCollectionViewCell.h
//  Dining
//
//  Created by Polaris on 12/24/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgFood;
//@property (strong, nonatomic) IBOutlet UIButton *btnCheck;
@property (strong, nonatomic) IBOutlet UIView *viewMask;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheck;
@property (nonatomic, assign) NSInteger isCheck;

@end
