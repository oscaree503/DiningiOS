//
//  CompassViewController.m
//  Dining
//
//  Created by Polaris on 12/15/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "CompassViewController.h"
#import "FoodCollectionViewCell.h"
#import "FoodItemTableViewCell.h"

@interface CompassViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionTop;
@property (strong, nonatomic) IBOutlet UITableView *tableviewFollowing;
@property (strong, nonatomic) IBOutlet UITableView *tableviewTopTags;

@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (strong, nonatomic) IBOutlet UIView *viewByFood;
@property (strong, nonatomic) IBOutlet UIView *viewFollowing;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *underLine;

@end

@implementation CompassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    _collectionTop.dataSource = self;
    _collectionTop.delegate = self;
    
    _tableviewFollowing.dataSource = self;
    _tableviewFollowing.delegate = self;
    
    _tableviewTopTags.dataSource = self;
    _tableviewTopTags.delegate = self;
    
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    
    _scrollView.scrollEnabled = NO;
    
    CGRect frame;
    
    frame.size = _scrollView.frame.size;
    
    frame.origin.x = 0;
    _viewTop.frame = frame;
    
    frame.origin.x = _scrollView.frame.size.width;
    _viewByFood.frame = frame;
    
    frame.origin.x = _scrollView.frame.size.width * 2;
    _viewFollowing.frame = frame;
    
    _scrollView.pagingEnabled = YES;
    
    [self initUI];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodItemTableViewCell* cell = (FoodItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"foodItemCell"];
    
    
    cell.lblFoodName.text = [[appController.foodItemArray objectAtIndex:indexPath.row] objectForKey:@"foodname"];
    cell.lblPrice.text = [NSString stringWithFormat:@"$%@", [[appController.foodItemArray objectAtIndex:indexPath.row] objectForKey:@"foodprice"]];
    cell.imgFood1.image = [UIImage imageNamed:[[appController.foodItemArray objectAtIndex:indexPath.row] objectForKey:@"foodimage1"]];
    cell.imgFood2.image = [UIImage imageNamed:[[appController.foodItemArray objectAtIndex:indexPath.row] objectForKey:@"foodimage2"]];
    cell.imgFood3.image = [UIImage imageNamed:[[appController.foodItemArray objectAtIndex:indexPath.row] objectForKey:@"foodimage3"]];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger aa;
    aa = [tableView tag];
    NSLog(@"%ld", aa);
    
    return [appController.foodItemArray count];
}

-(void) initUI{
    
    int kCellsPerRow = 2;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_collectionTop.collectionViewLayout;
    
    CGFloat availableWidthForCells = CGRectGetWidth(_collectionTop.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    
    CGFloat cellWidth = availableWidthForCells / (float)kCellsPerRow;
    
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return appController.collectionArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    FoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    
    cell.food_imageView.image =[UIImage imageNamed:[[appController collectionArray] objectAtIndex:indexPath.row]];
    
    
    return cell;
    
}

- (IBAction)onbtnClick:(id)sender {
    
//    NSLog(@"%d", [sender tag]);
    int x_offset = [sender tag] * _scrollView.frame.size.width;
    
    [ UIView animateWithDuration:.25 animations:^{
        [ _scrollView setContentOffset:CGPointMake(x_offset, 0)];
        
        _underLine.frame = CGRectMake(x_offset/3, _underLine.frame.origin.y, _underLine.frame.size.width  ,_underLine.frame.size.height);
    }];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int x_offset = _scrollView.contentOffset.x/3;
    _underLine.frame = CGRectMake(x_offset, _underLine.frame.origin.y, _underLine.frame.size.width  ,_underLine.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
