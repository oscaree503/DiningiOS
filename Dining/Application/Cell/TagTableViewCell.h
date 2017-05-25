//
//  TagTableViewCell.h
//  Dining
//
//  Created by Polaris on 12/23/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTag;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewTag;

@end
