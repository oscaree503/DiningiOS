//
//  HomeViewController.m
//  Dining
//
//  Created by Polaris on 12/13/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "HomeViewController.h"
#import "FoodCollectionViewCell.h"
#import "FoodTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+AFNetworking.h"

//#import "YPAPISample.h"

#import "UIViewController+KNSemiModal.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *btnCollection;
@property (strong, nonatomic) IBOutlet UIButton *btnTable;

@property (strong, nonatomic) IBOutlet UIImageView *imgMenu;
@property (strong, nonatomic) IBOutlet UIImageView *imgCollection;


@property (strong, nonatomic) IBOutlet UIView *viewFitersModal;


@property (strong, nonatomic) IBOutlet UIView *viewTotal;


@property (strong, nonatomic) IBOutlet UIButton *btnPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnType;
@property (strong, nonatomic) IBOutlet UIButton *btnMiles;

@property (strong, nonatomic) IBOutlet UIButton *btn050;
@property (strong, nonatomic) IBOutlet UIButton *btn50100;
@property (strong, nonatomic) IBOutlet UIButton *btn100150;

@property (strong, nonatomic) IBOutlet UIButton *btnSelectType;

@property (strong, nonatomic) IBOutlet UISlider *sliderBar;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;

@end

@implementation HomeViewController{
    int select_table;
    NSArray *businessArray;
}
- (IBAction)onSliderBar:(id)sender {
//    NSLog(@"%d", (int)_sliderBar.value);
    
    NSString *mileDistance;
    
    mileDistance = [NSString stringWithFormat:@"%ld", (long)_sliderBar.value];

    _lblDistance.text = mileDistance;
    
    
    NSLog(@"%@", mileDistance);
    
    [appController.searchFilter replaceObjectAtIndex:2 withObject:mileDistance];
    
    NSLog(@"%@", [appController.searchFilter objectAtIndex:2]);  // 2 -- distance
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initUI];
    
    // Do any additional setup after loading the view.
    select_table = 1;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _lblDistance.text = @"50 miles";
    
    [commonUtils setRoundedRectBorderButton:_btnPrice withBorderWidth:1 withBorderColor:RGBA(150, 150, 150, 1) withBorderRadius:0];
    [commonUtils setRoundedRectBorderButton:_btnType withBorderWidth:1 withBorderColor:RGBA(150, 150, 150, 1) withBorderRadius:0];
    [commonUtils setRoundedRectBorderButton:_btnMiles withBorderWidth:1 withBorderColor:RGBA(150, 150, 150, 1) withBorderRadius:0];
    
    [commonUtils setRoundedRectBorderButton:_btn050 withBorderWidth:1 withBorderColor:RGBA(150, 150, 150, 1) withBorderRadius:0];
    [commonUtils setRoundedRectBorderButton:_btn50100 withBorderWidth:1 withBorderColor:RGBA(150, 150, 150, 1) withBorderRadius:0];
    [commonUtils setRoundedRectBorderButton:_btn100150 withBorderWidth:1 withBorderColor:RGBA(150, 150, 150, 1) withBorderRadius:0];
    
    [commonUtils setRoundedRectBorderButton:_btnSelectType withBorderWidth:1 withBorderColor:RGBA(150, 150, 150, 1) withBorderRadius:0];
    
    [_sliderBar setMinimumValue:0.0f];
    [_sliderBar setMaximumValue:50.0f];
    [_sliderBar setValue:50.0f];
    
    [self displayWhat];
    [_imgMenu setImage:[UIImage imageNamed:@"menu.png"]];
    [_imgCollection setImage:[UIImage imageNamed:@"collection_selected.png"]];

    [_btnPrice setBackgroundColor:RGBA(255, 255, 255, 1)];

    
    
//--------- YELP -------------
    
//    businessArray = [[NSArray alloc] init];
    
//    NSString *term = @"dining";
//    NSString *location = @"New York";
//    NSString *startoffset;
//    
//    int num = 1;
//    startoffset = [NSString stringWithFormat:@"%d", num * 20];
//    
//    YPAPISample *APISample = [[YPAPISample alloc] init];
//    
//    [APISample queryTopBusinessInfoForTerm:term location:location offset:startoffset completionHandler:^(NSDictionary *searchResponseJSON, NSError *error) {
//        
//        [commonUtils showActivityIndicatorColored:self.view];
//        
//        if (error) {
//            NSLog(@"An error happened during the request: %@", error);
//        } else if (searchResponseJSON) {
//            businessArray = searchResponseJSON[@"businesses"];
//            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
//        } else {
//            NSLog(@"No business was found");
//        }
//    }];
    
    [self loadFoodData];

}

-(void)loadFoodData{
    
    [commonUtils showActivityIndicator:self.view];
    
    appController.yelpArray = [[NSMutableArray alloc] init];
    
    NSInteger price = [[appController.searchFilter objectAtIndex:1] integerValue];
    NSInteger filter_distance = [[appController.searchFilter objectAtIndex:2] integerValue];

    CLLocation *locA = [[CLLocation alloc] initWithLatitude:appController.myLatitude longitude:appController.myLongitude];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error)
        {
            NSDictionary *foodObject;

//            NSLog(@"%lu", (unsigned long)[objects count]);
            
            for (PFObject *objFood in objects){
                
                foodObject = @{
                               @"objID" : objFood.objectId,
                               @"FoodName" : [objFood objectForKey:@"FoodName"],
                               @"RestaurantName" : [objFood objectForKey:@"RestaurantName"],
                               @"FoodCity" : [objFood objectForKey:@"FoodCity"],
                               @"FoodLatitude" : [objFood objectForKey:@"FoodLatitude"],
                               @"FoodLongitude" : [objFood objectForKey:@"FoodLongitude"],
                               @"FoodImageURL" : [objFood objectForKey:@"FoodImageURL"],
                               @"FoodRating" : [objFood objectForKey:@"FoodRating"],
                               @"FoodReview" : [objFood objectForKey:@"FoodReview"],
                               @"PostUserID" : [objFood objectForKey:@"PostUser"],
                               @"FoodCategory" : [objFood objectForKey:@"FoodCategory"],
                               @"FoodPrice" : [objFood objectForKey:@"FoodPrice"]
                               };
                
                double res_latitude = [[foodObject objectForKey:@"FoodLatitude"] doubleValue];
                double res_longitude = [[foodObject objectForKey:@"FoodLongitude"] doubleValue];
                
                CLLocation *locB = [[CLLocation alloc] initWithLatitude:res_latitude  longitude:res_longitude];
                CLLocationDistance distance = [locA distanceFromLocation:locB];
                
                float me_TO_Res = [[NSString stringWithFormat:@"%.1f miles", distance/1609.34] floatValue];
                
                float foodPrice = [[foodObject objectForKey:@"FoodPrice"] floatValue];

                if ((price == 0 && filter_distance == 50) || ((price-50)*1.0 < foodPrice && price > (foodPrice*1.0) && me_TO_Res<=(filter_distance*1.0))){
                        [appController.yelpArray addObject:foodObject];
//                        [appController.totalFood addObject:foodObject];
                }
            }
            


        }
        
        [_tableView reloadData];
        [_collectionView reloadData];
        
    }];
    

    [commonUtils hideActivityIndicator];
    
    PFQuery *alluser_query = [PFUser query];
    alluser_query = [alluser_query whereKey:@"objectId" notEqualTo:[appController.current_user objectForKey:@"user_objectID"]];
    appController.allUser_data = [alluser_query findObjects];



}
//- (void) reloadData {
//    
//    [commonUtils hideActivityIndicator];
//    [_tableView reloadData];
//    [_collectionView reloadData];
////    appController.yelpArray = businessArray;
//    
//}


- (IBAction)onPriceBtn:(id)sender {
    
    [_btnPrice setBackgroundColor:RGBA(223, 108, 63, 1)];
    [_btnType setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_btnMiles setBackgroundColor:RGBA(255, 255, 255, 1)];

}
- (IBAction)onTypeBtn:(id)sender {
    [_btnPrice setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_btnType setBackgroundColor:RGBA(223, 108, 63, 1)];
    [_btnMiles setBackgroundColor:RGBA(255, 255, 255, 1)];    // 0 - food type
}
- (IBAction)onMilesBtn:(id)sender {
    [_btnPrice setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_btnType setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_btnMiles setBackgroundColor:RGBA(223, 108, 63, 1)];
}

//  *btn050; *btn50100; *btn100150;

- (IBAction)onPrice050:(id)sender {
    [_btn050 setBackgroundColor:RGBA(223, 108, 63, 1)];
    [_btn50100 setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_btn100150 setBackgroundColor:RGBA(255, 255, 255, 1)];
    
    [appController.searchFilter replaceObjectAtIndex:1 withObject:@"50"];  // 1 -- price
    
}
- (IBAction)onprice50100:(id)sender {
    [_btn050 setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_btn50100 setBackgroundColor:RGBA(223, 108, 63, 1)];
    [_btn100150 setBackgroundColor:RGBA(255, 255, 255, 1)];
    
    [appController.searchFilter replaceObjectAtIndex:1 withObject:@"100"];
}
- (IBAction)onPrice100150:(id)sender {
    [_btn050 setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_btn50100 setBackgroundColor:RGBA(255, 255, 255, 1)];
    [_btn100150 setBackgroundColor:RGBA(223, 108, 63, 1)];
    
    [appController.searchFilter replaceObjectAtIndex:1 withObject:@"150"];
}

//*btn015miles, *btn1530miles, *btn3050miles;

- (IBAction)onFilterBtn:(id)sender {

    [self presentSemiView:self.viewFitersModal withOptions:@{
                                       KNSemiModalOptionKeys.pushParentBack : @(NO),
                                       KNSemiModalOptionKeys.parentAlpha : @(0.4),
                                       KNSemiModalOptionKeys.animationDuration : @(0.3)
                                                    }];
}

- (IBAction)onFilterDone:(id)sender {
    
    [self dismissSemiModalView];
    
    [self loadFoodData];
//    [_tableView reloadData];
//    [_collectionView reloadData];
}

-(void) initUI{
    
    int kCellsPerRow = 2;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_collectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(_collectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / (float)kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    [self displayWhat];
    [_imgMenu setImage:[UIImage imageNamed:@"menu_selected.png"]];
    [_imgCollection setImage:[UIImage imageNamed:@"collection.png"]];

}

-(void)displayWhat{
    if (select_table == 0) {
        [_tableView setHidden:NO];
        [_collectionView setHidden:YES];
    } else {
        [_tableView setHidden:YES];
        [_collectionView setHidden:NO];
    }
}

- (IBAction)onTableViewBtn:(id)sender {
    select_table = 0;
    
    [_imgMenu setImage:[UIImage imageNamed:@"menu_selected.png"]];
    [_imgCollection setImage:[UIImage imageNamed:@"collection.png"]];
    [self displayWhat];
}
- (IBAction)onCollectionViewBtn:(id)sender {
    
    select_table = 1;
    [_imgMenu setImage:[UIImage imageNamed:@"menu.png"]];
    [_imgCollection setImage:[UIImage imageNamed:@"collection_selected.png"]];
    [self displayWhat];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return appController.yelpArray == nil ? 0 : [appController.yelpArray count];
}

-(FoodTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodTableViewCell *cell = (FoodTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"foodTableCell"];
    appController.totalFood = appController.yelpArray;
    
    NSDictionary *yelpInfo = [appController.yelpArray objectAtIndex:indexPath.row];
        
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:appController.myLatitude longitude:appController.myLongitude];
    
    double res_latitude = [[yelpInfo objectForKey:@"FoodLatitude"] doubleValue];
    double res_longitude = [[yelpInfo objectForKey:@"FoodLongitude"] doubleValue];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:res_latitude  longitude:res_longitude];
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    cell.lblDistance.text = [NSString stringWithFormat:@"%.1f miles", distance/1609.34];
    
    [cell.imgFood setImageWithURL:[NSURL URLWithString:yelpInfo[@"FoodImageURL"]]];
    
    cell.lblFoodName.text = [yelpInfo objectForKey:@"FoodName"];
   
    cell.lblFoodLocation.text = [[[yelpInfo objectForKey:@"RestaurantName"] stringByAppendingString:@", "] stringByAppendingString:[yelpInfo objectForKey:@"FoodCity"]];
    
//    NSLog(@"%@", [yelpInfo objectForKey:@"PostUserID"]);
    
//    [query whereKey:@"objectId" equalTo:[yelpInfo objectForKey:@"PostUserID"]];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:[yelpInfo objectForKey:@"PostUserID"]];
    NSArray *users = [query findObjects];
    PFUser *user = [users objectAtIndex:0];

    [cell.imgOwnerPhoto setImageWithURL:[NSURL URLWithString:user[@"photo"]]];
    cell.lblOwnerName.text = user[@"fullname"];


    [cell.btnLike setTag:indexPath.row];
    
//    [cell.imgOwnerPhoto setImageWithURL:[NSURL URLWithString:[appController.current_user objectForKey:@"user_photoURL"]]];

    if (cell.isLike == 1){
        [cell.imgLike setImage:[UIImage imageNamed:@"heart_select"]];
    } else {
        [cell.imgLike setImage:[UIImage imageNamed:@"heart"]];
    }
    
    cell.lblPrice.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%@", [yelpInfo objectForKey:@"FoodPrice"]]];
    
    cell.btnLike.tag = indexPath.row;
    cell.btnShare.tag = indexPath.row;
    
    [cell.btnLike addTarget:self action:@selector(onLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnShare addTarget:self action:@selector(onShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    appController.sel_item = indexPath.row;
    
    UIViewController *foodDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fooddetail"];
    [self presentViewController:foodDetailVC animated:YES completion:nil];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    appController.sel_item = indexPath.row;
    
    UIViewController *foodDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fooddetail"];
    [self presentViewController:foodDetailVC animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return [appController.yelpArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    
//        cell.food_imageView.image =[UIImage imageNamed:[[appController collectionArray] objectAtIndex:indexPath.row]];
    
    NSDictionary *yelpInfo = appController.yelpArray[indexPath.row];
    
    [cell.food_imageView setImageWithURL:[NSURL URLWithString:yelpInfo[@"FoodImageURL"]]];

    return cell;
}
- (IBAction)onLikeBtn:(id)sender {
    
    FoodTableViewCell *cell = (FoodTableViewCell*)[[[sender superview] superview] superview];
    
    cell.isLike = 1;
    
    [_tableView reloadData];
    
    PFObject *likeFood = [PFObject objectWithClassName:@"FoodLikeSharePost"];
    likeFood[@"UserID"] = [appController.current_user objectForKey:@"user_objectID"];
    likeFood[@"FoodID"] = [[appController.yelpArray objectAtIndex:[sender tag]] objectForKey:@"objID"];
    NSInteger like = 0;
    NSString *alert = [[appController.yelpArray objectAtIndex:[sender tag]] objectForKey:@"FoodName"];
    
    alert = [@"You liked " stringByAppendingString:alert];
    alert = [alert stringByAppendingString:@"."];
    
    likeFood[@"Status"] = [NSNumber numberWithInteger:like];
    
    NSLog(@"%@", likeFood[@"UserID"]);
    NSLog(@"%@", likeFood[@"FoodID"]);
    
//    likeFood[@"FoodID"] = @"Sean Plott";
//    likeFood[@"cheatMode"] = @NO;
    [likeFood saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [appController.vAlert doAlert:@"Notice" body:alert duration:1.3f done:^(DoAlertView *alertView) {
            }];
            
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Connection error!" duration:1.3f done:^(DoAlertView *alertView) {
            }];
        }
    }];
    
//    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
//    cell.imgLike.image = [UIImage imageNamed:@"heart_select"];
    
//    [_tableView reloadData];
    
//    PFObject *tblFood = [PFObject objectWithClassName:@"Food"];
//    
//    NSInteger nIndex = [sender tag];
// 
//    
//    NSDictionary *select_food = [appController.yelpArray objectAtIndex:nIndex];
//    
//    NSString *foodImageName = [[[[select_food objectForKey:@"categories"] objectAtIndex:0] objectAtIndex:1] stringByAppendingString:@".png"];
//    
//    NSURL *url = [NSURL URLWithString:[select_food objectForKey:@"image_url"]];
//    NSData *dataImg = [NSData dataWithContentsOfURL:url];
//    UIImage *FoodImg = [UIImage imageWithData:dataImg];
//    
//    NSData *data = UIImagePNGRepresentation(FoodImg);
//    PFFile *foodImage = [PFFile fileWithName:foodImageName data:data];
//
//    tblFood[@"RestaurantName"] = [select_food objectForKey:@"name"];
//    tblFood[@"FoodCity"] = [[select_food objectForKey:@"location"] objectForKey:@"city"];
//    
//    NSString *foodName = [[[select_food objectForKey:@"categories"] objectAtIndex:0] objectAtIndex:0];
//    
////    NSLog(@"%@", foodName);
//    
//    tblFood[@"FoodName"] = foodName;
//    
//    double food_latitude = [[[[select_food objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"latitude"] doubleValue];
//    tblFood[@"FoodLatitude"] = [NSNumber numberWithDouble:food_latitude];
//    double food_longitude = [[[[select_food objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"longitude"] doubleValue];
//    tblFood[@"FoodLongitude"] = [NSNumber numberWithDouble:food_longitude];
//    
//    tblFood[@"FoodRating"] = [NSNumber numberWithDouble:[[select_food objectForKey:@"rating"] doubleValue]];
//    tblFood[@"FoodReview"] = [select_food objectForKey:@"snippet_text"];
//   
////    tblFood[@"UserID"] = appController.user_objectID;
//    
//    [foodImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
//        if (!error){
////            NSLog(@"%@", foodImage.url);
//            tblFood[@"FoodImageURL"] = foodImage.url;
//            [tblFood saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
//                if (!error){
////                    NSLog(@"%@", tblFood.objectId);
//                }
//            }];
//        } else {
//            NSLog(@"error");
//        }
//    }];
    
//    }
    
}

- (IBAction)onShareBtn:(id)sender {
}



@end
