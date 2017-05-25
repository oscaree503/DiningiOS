//
//  TagTableViewCell.m
//  Dining
//
//  Created by Polaris on 12/23/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "TagTableViewCell.h"
#import "TagCollectionViewCell.h"

@implementation TagTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _collectionViewTag.dataSource = self;
    _collectionViewTag.delegate = self;
    
    [self initUI];
//    collectionTagCell    
    
    
}
-(TagCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionTagCell" forIndexPath:indexPath];
    
//    NSArray *collectiondata =
    NSString *tagname = [[appController.tag_name objectAtIndex:appController.nindex] objectForKey:@"TagName"];
    NSLog(@"%@",tagname);
    NSLog(@"%d", appController.nindex);
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger ct = [[[appController.tag_name objectAtIndex:appController.nindex] objectForKey:@"countTag"] integerValue];
    
    return ct;

}

-(void) initUI{
    
    int kCellsPerRow = 3, kCellsPerCol = 1;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*) _collectionViewTag.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(_collectionViewTag.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / (float)kCellsPerRow;
    
    CGFloat availableHeightForCells = CGRectGetHeight(_collectionViewTag.frame) - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - flowLayout.minimumInteritemSpacing * (kCellsPerCol - 1);
    CGFloat cellHeight = availableHeightForCells / (float)kCellsPerCol;
    
    flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
